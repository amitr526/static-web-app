#!/usr/bin/env bash

VERSION="master"
URL="https://github.com/Azure/azure-quickstart-templates/blob/${VERSION}/quickstarts/microsoft.documentdb/cosmosdb-sql-serverless/main.bicep"

echo "# Downloaded from ${URL} on $(date) using infra/download.sh" > infra/main.bicep
curl -L "${URL}" >> infra/main.bicep
echo OK