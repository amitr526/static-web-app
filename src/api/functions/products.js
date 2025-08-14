const { app } = require('@azure/functions');
import { DefaultAzureCredential } from '@azure/identity';
import { CosmosClient } from '@azure/cosmos';

const credential = new DefaultAzureCredential();
const endpoint = process.env.COSMOS_ENDPOINT;

app.http('products', {
    methods: ['GET'],
    authLevel: 'function',
    handler: async (request, context) => {
        context.log('JavaScript HTTP trigger function processed a request.');
        
        try {
            const client = new CosmosClient({
                endpoint,
                aadCredentials: credential,
                connectionPolicy: {
                    requestTimeout: 10000,
                },
            });
            const container = database.container('products');
            const querySpec = {
                query: 'SELECT * FROM products p WHERE p.category = @category',
                parameters: [{
                    name: '@category',
                    value: 'gear-surf-surfboards'
                }
            ]};
            
            const { resources: items } = await container.items.query(querySpec).fetchAll();
            
            return {
                body: JSON.stringify(items),
                headers: {
                    'Content-Type': 'application/json'
                }
            };
        } catch (error) {
            context.log.error('Error traversing Cosmos DB items:', error);
            return {
                status: 500,
                body: JSON.stringify({ error: 'Failed to retrieve items' })
            };
        }
    }
});

