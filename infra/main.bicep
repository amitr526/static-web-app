@description('Location for all resources')
param location string = resourceGroup().location

@description('Unique name for the application')
param appName string = 'staticwebapp${uniqueString(resourceGroup().id)}'

// Cosmos DB Account
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: 'cosmos-${appName}'
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

// Cosmos DB Database
resource cosmosDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  parent: cosmosDbAccount
  name: 'MainDatabase'
  properties: {
    resource: {
      id: 'MainDatabase'
    }
  }
}

// Cosmos DB Container
resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  parent: cosmosDatabase
  name: 'Items'
  properties: {
    resource: {
      id: 'Items'
      partitionKey: {
        paths: [
          '/id'
        ]
        kind: 'Hash'
      }
    }
    options: {
      throughput: 400
    }
  }
}

// Static Web App
resource staticWebApp 'Microsoft.Web/staticSites@2022-03-01' = {
  name: 'web-${appName}'
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: ''
    branch: ''
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

// Cosmos DB Access Configuration
resource staticWebAppSettings 'Microsoft.Web/staticSites/config@2022-03-01' = {
  parent: staticWebApp
  name: 'appsettings'
  properties: {
    COSMOS_ENDPOINT: cosmosDbAccount.properties.documentEndpoint
    COSMOS_KEY: cosmosDbAccount.listKeys().primaryMasterKey
  }
}

// Outputs
output cosmosEndpoint string = cosmosDbAccount.properties.documentEndpoint
output staticWebAppName string = staticWebApp.name
