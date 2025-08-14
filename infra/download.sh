#!/usr/bin/env bash

VERSION="refs/heads/master"
URL="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/${VERSION}/quickstarts/microsoft.documentdb/cosmosdb-sql-serverless/main.bicep"

echo "// # Downloaded from: [${URL}] on: [$(date)] using infra/download.sh" > infra/main.bicep
curl -L "${URL}" >> infra/main.bicep
echo OK