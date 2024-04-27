import fs from 'fs';
import jsforce from 'jsforce';
import { GraphQLList, printSchema } from 'graphql';
import {
    GraphQLObjectType,
    GraphQLString,
    GraphQLInt,
    GraphQLFloat,
    GraphQLBoolean,
    GraphQLID,
    GraphQLScalarType,
    GraphQLSchema
} from 'graphql';
import dotenv from 'dotenv';

// dotenv
dotenv.config();

const username = process.env.SF_USERNAME!;
const password = process.env.SF_PASSWORD!;
const token = process.env.SF_TOKEN; // Salesforce security token
const loginUrl = process.env.SF_INSTANCE_URL; // Salesforce login URL

console.log({
    username,
    password,
    token,
    loginUrl
});

const conn = new jsforce.Connection({
    loginUrl
});

async function fetchSObjectMetadata() {
    try {
        const userInfo = await conn.login(username, password + token);
        console.log('Logged in as', userInfo);
        const describe = await conn.describeGlobal();
        console.log('Fetched global describe:', describe);
        const sObjectsMetadata = await Promise.all(
            describe.sobjects.map(async (sObject) => {
                if (!sObject.custom) {
                    console.log(`Skipping ${sObject.name}: not a custom object`);
                    return null;
                }

                const metadata = await conn.sobject(sObject.name).describe();
                return { name: sObject.name, fields: metadata.fields };
            })
        );

        // filter to only include objects with at least one field and only custom objects
        return sObjectsMetadata.filter(Boolean).filter(sObject => sObject!.fields.length > 0);
    } catch (error) {
        console.error('Error fetching metadata:', error);
        throw error;
    }
}

function getGraphQLType(sfType: string) {
    const typeMapping = {
        'string': GraphQLString,
        'textarea': GraphQLString,
        'email': GraphQLString,
        'id': GraphQLID,
        'phone': GraphQLString,
        'url': GraphQLString,
        'currency': GraphQLFloat,
        'double': GraphQLFloat,
        'integer': GraphQLInt,
        'percent': GraphQLFloat,
        'boolean': GraphQLBoolean,
        'date': new  GraphQLScalarType({
             name: 'Date',
              description: 'A date',
              parseValue: (value: any) => new Date(value),
            serialize: (value: any) => value.toISOString(),
            parseLiteral: (ast: any) => ast.value,
        }),
        'datetime': new GraphQLScalarType({
            name: 'DateTime',
            description: 'A date and time',
            parseValue: (value: any) => new Date(value),
            serialize: (value: any) => value.toISOString(),
            parseLiteral: (ast: any) => ast.value,
        }),
        'picklist': new GraphQLScalarType({
            name: 'Picklist',
            description: 'A picklist value',
            serialize: (value: any) => value,
             parseValue: (value: any) => value,
             parseLiteral: (ast: any) => ast.value,
        }),
        // Add other Salesforce field types as needed.
    };

    let typing: any = GraphQLString; // Default to String if not found in the mapping

    if (typeMapping[sfType.toLowerCase() as keyof typeof typeMapping]) {
        typing = typeMapping[sfType.toLowerCase() as keyof typeof typeMapping];
        console.log(`Found a match for ${sfType}: ${typing}`);
    }
    else {
        console.log(`No match found for ${sfType}: using default String`);
        typing = sfType;
    }



    return (typeMapping as any)[sfType.toLowerCase() as string] || new GraphQLScalarType({
        name: sfType,
        description: 'A  custom scalar type for ' + sfType,
        serialize(value) { return value; },
        parseValue(value) { return value; },
        parseLiteral(ast) { return (ast as any).value; }
    });
}

function buildGraphQLTypes(sObjects: any[]) {
    const gqlTypes = sObjects.reduce((types: { [x: string]: GraphQLObjectType<any, any>; }, sObject: { fields: any[]; name: string | number; }) => {
        // Initialize the fields object
        const fields = {};

        // Populate the fields object
        sObject.fields.forEach((field: { name: string | number; type: string; }) => {
            // Use the mapping function to get the correct GraphQL type
            (fields as any)[field.name] = { type: getGraphQLType(field.type) };
        });

        console.log(`Fields for ${sObject.name}:`, fields);

        // Create and store the new GraphQLObjectType
        types[sObject.name] = new GraphQLObjectType({
            name: sObject.name as string,
            fields: fields  // Correctly assign the fields object
        });

        return types;
    }, {});

    return new GraphQLSchema({
        query: new GraphQLObjectType({
            name: 'Query',
            fields: () => gqlTypes  // Ensuring fields are set as a function for lazy evaluation
        })
    });
}

async function generateSchema() {
    const metadata = await fetchSObjectMetadata();
    console.log(metadata);
    if (!metadata || metadata.length === 0) {
        console.error('No metadata available or schema generation prerequisites not met.');
        return;
    }

    const schema = buildGraphQLTypes(metadata);
    // console.log('Generated GraphQL Types:', JSON.stringify(schema.getTypeMap(), null, 2));
    // console.log('Generated GraphQL Schema:', JSON.stringify(schema, null, 2));

    console.log('Generated GraphQL Schema:', printSchema(schema));

    // get all object names so that we can replace then in the schema with the correct types instead of genericscalar





    // Write out the ERD to a file
    let erdData = metadata.map((sObject) => {
        if (!sObject) {
            return null;
        }
        return {
            name: sObject.name,
            fields: sObject.fields.map((field) => ({
                name: field.name,
                type: getGraphQLType(field.type)
            })), // End of nested array
        };
    })

    let erdData2 = erdData.reduce((erd, sObject, index) => {
        if (!sObject) {
        }
        else {
            //@ts-ignore
            erd[sObject.name] = erdData[index];
        }
        return erd;
    }, {});

    const erdJson = JSON.stringify(erdData2, null, 2);
    fs.writeFileSync('erd.json', erdJson);

    console.log(`ERD written to file: erd.json`);
}

// Call the generateSchema function
generateSchema();
