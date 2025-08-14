
SHELL := /bin/bash

location?=northeurope

.PHONY: all status outputs test clean

# https://learn.microsoft.com/en-us/azure/static-web-apps/publish-bicep
all:
	az account show
	az deployment group create \
		--resource-group $(rgName) \
		--template-file main.bicep
