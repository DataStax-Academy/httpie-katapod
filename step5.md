<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Exploring Stargate with HTTPie</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:kirsten.hunter@datastax.com">email</a> or <a href="https://linkedin.com/in/synedra">LinkedIn</a>.</span>
  </div>
</div>

# Exploring Stargate APIs from the command line - Document API

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the Document API.  This API deserves a little more explanation, as it is not what you might think of as a standard Cassandra database.  In this API, you give the database JSON objects and can then work with them based on their contents.  This database model doesn't require a schema, it just has the documents you put in there, which are placed in collections that you define.

* Document - Choose a Namespace
* Document - Write a Document
* Document - Read documents
* Document - Update documents
* Document - Delete document

### 1. Create a collection

You'll need a collection to hold your documents.  This is separate from the database name (we're using workshops) or namespace (in this case, library) that contains it.  If you don't create the collection, it will automatically be created for you when you insert your first document.

```
http POST :/rest/v2/namespaces/library/collections json:='{"name":"library"}'
```

Check to make sure that it got created:
http :/rest/v2/namespaces/library/collections

## 2. Write a document

Create a document without specifying the ID 

```
http POST :/rest/v2/namespaces/library/collections/library json:='
{
  "stuff": "Random ramblings",
  "other": "I need a document with a set value for a test."
}'
```

Create a document with a specific ID:

```
http PUT :/rest/v2/namespaces/library/collections/library/long-ID-number json:='
{
  "stuff": "long-ID-number",
  "other": "I need a document with a set value for a test."
}'
```

Add a document with data:

http POST :/rest/v2/namespaces/library/collections/library json:='
{
    "reader": {
       "name": "Amy Smith",
       "user_id": "12345",
       "birthdate": "10-01-1980",
       "email": {
           "primary": "asmith@gmail.com",
           "secondary": "amyispolite@aol.com"
       },
       "address": {
           "primary": {
               "street": "200 Antigone St",
               "city": "Nevertown",
               "state": "MA",
               "zip-code": 55555
           },
           "secondary": {
               "street": "850 2nd St",
               "city": "Evertown",
               "state": "MA",
               "zip-code": 55556
           }
       },
       "reviews": [
           {
               "book-title": "Moby Dick", 
               "rating": 4, 
               "review-date": "04-25-2002",
               "comment": "It was better than I thought."
           },
           {
               "book-title": "Pride and Prejudice", 
               "rating": 2, 
               "review-date": "12-02-2002",
               "comment": "It was just like the movie."
           }
       ]
    }
}'

Note the difference between using POST and PUT. The POST request is used to insert new documents when you want the system to auto-generate the document-dd. The PUT request is used to insert a new document when you want to specify the document-id.

Here's a document we'll use in later examples, PUT with a specific ID.

http PUT :/rest/v2/namespaces/library/collections/library/native-son-doc-id json:='
     {
        "book": {
            "title": "Native Son",
            "isbn": "12322",
            "author": [
                "Richard Wright"
            ],
            "pub-year": 1930,
            "genre": [
                "poverty",
                "action"
            ],
            "format": [
                "hardback",
                "paperback",
                "epub"
            ],
            "languages": [
                "English",
                "German",
                "French"
            ]
        }
    }
'

It is often convenient to insert several documents into a collection with one request. The Document API has an endpoint that allows for batches of JSON documents to be inserted into the same collection. 

http POST :/rest/v2/namespaces/library/collections/library/batch' json:='
[{
     "reader": {
        "name": "Jane Doe",
        "user_id": "12345",
        "birthdate": "10-01-1980",
        "email": {
            "primary": "jdoe@gmail.com",
            "secondary": "jane.doe@aol.com"
        },
        "address": {
            "primary": {
                "street": "100 Main St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55555
            },
            "secondary": {
                "street": "850 2nd St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55556
            }
        },
        "reviews": [
            {
                "book-title": "Moby Dick", 
                "rating": 3, 
                "review-date": "02-02-2002",
                "comment": "It was okay."
            },
            {
                "book-title": "Pride and Prejudice", 
                "rating": 5, 
                "review-date": "03-02-2002",
                "comment": "It was a wonderful book! I loved reading it."
            }
        ]
     }
  },
  {
    "reader": {
       "name": "John Jones",
       "user_id": "54321",
       "birthdate": "06-11-2000",
       "email": {
           "primary": "jjones@gmail.com",
           "secondary": "johnnyj@aol.com"
       },
       "address": {
           "primary": {
               "street": "4593 Webster Ave",
               "city": "Paradise",
               "state": "CA",
               "zip-code": 95534
           }
       },
       "reviews": [
           {
               "book-title": "Moby Dick", 
               "rating": 2, 
               "review-date": "03-15-2020",
               "comment": "Boring book that I had to read for class."
           },
           {
               "book-title": "Pride and Prejudice", 
               "rating": 2, 
               "review-date": "0-02-2020",
               "comment": "Another boring book."
           }
       ]
    }
}
]'

This batch has documents we'll use in later examples:

http POST :/rest/v2/namespaces/library/collections/library/batch' json:='
 [{
     "book": {
         "title": "Moby Dick",
         "isbn": "12345",
         "author": [
             "Herman Melville"
         ],
         "pub-year": 1899,
         "genre": [
             "adventure",
             "ocean",
             "action"
         ],
         "format": [
             "hardback",
             "paperback",
             "epub"
         ],
         "languages": [
             "English",
             "German",
             "French"
         ]
     }
    },
 {
     "book": {
         "title": "Pride and Prejudice",
         "isbn": "45674",
         "author": [
             "Jane Austen"
         ],
         "pub-year": 1890,
         "genre": [
             "romance",
             "England",
             "regency"
         ],
         "format": [
             "hardback",
             "paperback",
             "epub"
         ],
         "languages": [
             "English",
             "Japanese",
             "French"
         ]
     }
 },
     {
        "book": {
            "title": "The Art of French Cooking",
            "isbn": "19922",
            "author": [
                "Julia Child",
                "Simone Beck",
                "Louisette Bertholle"
            ],
            "pub-year": 1960,
            "genre": [
                "cooking",
                "French cuisine"
            ],
            "format": [
                "hardback",
                "paperback",
                "epub"
            ],
            "languages": [
                "English",
                "German",
                "French",
                "Belgian"
            ]
        }
    }
]'

Add a reader to be used in future examples:

http POST :/rest/v2/namespaces/library/collections/library/John-Smith' json:=
STARGATE DOCUMENTATION
DEVELOPING WITH STARGATE APIS
DEVELOP WITH DOCUMENT
Edit this Page
Developing with the Stargate Document API

Stargate is a data gateway deployed between client applications and a database. The Stargate Document API modifies and queries data stored as unstructured JSON documents in collections. Because the Document API uses schemaless data, no data modeling is required!
If the Document API is used with Apache Cassandra, document indexing is accomplished with Cassandra secondary indexes.
If the Document API is used with DataStax Enterprise, SAI indexing is used. The blog The Stargate Cassandra Documents API describes the underlying structure used to store collections.
Information about namespaces and collections
To use the Document API, you must define a namespace that will store collections. Collections can store either unstructured JSON documents or documents with a defined JSON schema. Documents can themselves hold multiple documents. Multiple collections are contained in a namespace, but a collection cannot be contained in multiple namespaces.
Only namespaces need to be specifically created. Collections are specified when a document is inserted.
Prerequisites
If you are looking to just get started, DataStax Astra Database-as-a-Service can get you started with no install steps.
Install cURL, a utility for running REST, Document, or GraphQL queries on the command line.
[Optional] If you prefer, you can use Postman as a client interface for exploring the APIs
You will also find links to downloadable collections and environments in Using Postman
[Optional] If you going to use the GraphQL API, you will want to use the GraphQL Playground to deploy schema and execute mutations and queries.
[Optional] For the REST and Document APIs, you can use the Swagger UI.
Install Docker for Desktop
Pull a Stargate Docker image
Cassandra 4.0
Cassandra 3.x
DSE 6.8
v2
For Stargate v2, you’ll need to pull an image for coordinator, plus an image for each API that you wish to run: restapi, graphql, and docsapi. The coordinator image contains a Apache Cassandra™ backend, the Cassandra Query Language (CQL), and the gRPC API.
The following are the commands for each of those images using the tag v2:
docker pull stargateio/coordinator-4_0:v2
docker pull stargateio/restapi:v2
docker pull stargateio/docsapi:v2
docker pull stargateio/graphqlapi:v2
v1
Run the Stargate Docker image
Cassandra 4.0
Cassandra 3.x
DSE 6.8
v2
Use this docker-compose shell script to start the coordinator and APIs in developer mode. The easiest way to do that is to navigate to the <install_location>/stargate/docker-compose directory, and run the script. You will want to run, for example:
./start_cass_4_0_dev_mode.sh
This command will start using the latest available coordinator and API images with the v2 tag.
You may also select a specific image tag using the -t <image_tag> option. A list of the available tags for the coordinator can be found here.
v1
Generate an authorization token to access the interface by following the instructions in Table-based authentication/Authorization
API reference
If you prefer to learn using a QuickStart, try out the Stargate Document QuickStart. To view the API Reference, see Stargate Document API.
Creating a namespace
In order to use the Document API, you must create the namespace as a container that will store collections, which in turn store documents. Documents can themselves hold multiple documents. Multiple collections are contained in a namespace, but a collection cannot be contained in multiple namespaces.
Only namespaces need to be specifically created. Collections are specified when a document is inserted. An optional setting, replicas, defines the number of data replicas the database will store for the namespace. If no replica is defined, then for a namespace in a single datacenter cluster, the default is 1, and for a multiple-datacenter cluster, the default is 3 for each datacenter.
Simple namespace
Send a POST request to /v2/schemas/namespaces. In this example we use test for the name, and no replicas setting, to default to 1. docs/build/stargate/stargate/develop/api-doc/doc-creating-namespace.html
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request POST 'http://localhost:8180/v2/schemas/namespaces' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data '{
    "name": "test"
}'
The generated authorization token and the content type are passed with --header. The token must be identified as X-Cassandra-Token so that cluster recognizes the token and its value. The specified name for the namespace is passed as JSON data using --data.
cURL can use any of the shortcut or longhand flags:
Shortcut	Longhand	Example	Description
-L
--location
-L http://localhost:8082
Retrieves the URL listed, even if it has moved
-X
--request
-X PUT
Defines the type of REST operation, such as POST, GET, and DELETE
-H
'--header'
'-H "X-Cassandra-Token: $AUTH_TOKEN"'
Passes header information, such as auth tokens and the content type
'-d'
'--data'
-d '{ "name": "test", "replicas": 1 }'
Passes data as part of the request body
'-g'
'--globoff'
No argument
The -globoff flag switches off the URL globbing parser, and you can specify URLs that contain the characters {}[] without having curl interpret them. This option is handy for making the URLs for Document API calls cleaner to read, with less escaping.
Set replicas in simple namespace
To set the replicas, send a POST request to /v2/schemas/namespaces. In this example we use test for the name, and 2 for the number of data replicas.
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request POST 'http://localhost:8180/v2/schemas/namespaces' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data '{
    "name": "test",
    "replicas": 2
}'
Namespace for multiple datacenters
For a multiple-datacenter cluster, a namespace is defined datacenters. Send a POST request to /v2/schemas/namespaces. In this example we use myworld-dcs for the name, the datacenters are dc1 and dc2, where dc1 defaults to 3 replicas and dc2 is set to 5 replicas.
cURL command (/v2)
cURL command (/v1)
Result
curl -L -X POST 'http://localhost:8180/v2/schemas/namespaces' \
-H "X-Cassandra-Token: $AUTH_TOKEN" \
-H 'Content-Type: application/json' \
-d '{
    "name": "test-dcs",
    "datacenters": [ {"name": "dc1"}, {"name": "dc2", "replicas": 5} ]
}'
Checking namespace existence
To check if a namespaces exist, execute a Document API query with cURL to find all the namespaces:
cURL command (/v2)
cURL command (/v1)
Result
curl -L -X GET 'http://localhost:8180/v2/schemas/namespaces' \
-H "X-Cassandra-Token: $AUTH_TOKEN" \
-H 'Content-Type: application/json'
To get a particular namespace, specify the namespace in the URL:
cURL command (/v2)
cURL command (/v1)
Result
curl -X GET 'http://localhost:8180/v2/schemas/namespaces/test' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json'
Deleting a namespace
Send a DELETE request to /v2/schemas/namespaces/{namespace_name} to delete a namespace. All collections and documents will be deleted along with the namespace.
cURL command (/v2)
cURL command (/v1)
curl -L -X DELETE 'http://localhost:8180/v2/schemas/namespaces/test' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json'
Deletions do not return any data.
Creating a collection
In the Document API, collections are created in a {glossary_url}gloss_namespace.html[namespace]. Collections store documents. Multiple collections are contained in a namespace, but a collection cannot be contained in multiple namespaces.
Only namespaces need to be specifically created. Collections can be created either as an empty collection first, or created with the first document creation in a collection.
Creating an empty collection
Send a POST request to /v2/namespaces. In this example we use library for the name.
cURL command (/v2)
cURL command (/v1)
Result
curl --location \
--request POST 'http://localhost:8180/v2/namespaces/test/collections' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data '{
  "name": "library"
}'
The generated authorization token and the content type are passed with --header. The token must be identified as X-Cassandra-Token so that cluster recognizes the token and its value. The specified name for the namespace is passed as JSON data using --data.
cURL can use any of the shortcut or longhand flags:
Shortcut	Longhand	Example	Description
-L
--location
-L http://localhost:8082
Retrieves the URL listed, even if it has moved
-X
--request
-X PUT
Defines the type of REST operation, such as POST, GET, and DELETE
-H
'--header'
'-H "X-Cassandra-Token: $AUTH_TOKEN"'
Passes header information, such as auth tokens and the content type
'-d'
'--data'
-d '{ "name": "test", "replicas": 1 }'
Passes data as part of the request body
'-g'
'--globoff'
No argument
The -globoff flag switches off the URL globbing parser, and you can specify URLs that contain the characters {}[] without having curl interpret them. This option is handy for making the URLs for Document API calls cleaner to read, with less escaping.
Add JSON schema to a collection
To set JSON schema that a collection’s documents will use, send a PUT request to /v2/namespaces/test/collections/library. In this example, a collection is created to store a Person object that has three properties: first name, last name, and age:
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request PUT 'http://localhost:8180/v2/namespaces/test/collections/library2/json-schema' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw '{
  "title": "Person",
  "type": "object",
  "properties": {
    "firstName": {
      "type": "string",
      "description": "The person'\''s first name."
    },
    "lastName": {
      "type": "string",
      "description": "The person'\''s last name."
    },
    "age": {
      "description": "Age in years which must be equal to or greater than zero.",
      "type": "integer",
      "minimum": 0
    }
  }
}
'
JSON schema support is experimental. Also, partial updates of data are not allowed if JSON schema is defined.
Checking collection existence
To check if a collection exists, execute a GET request to find all the collections:
cURL command (/v2)
cURL command (/v1)
Result
curl -L -X GET 'http://localhost:8180/v2/namespaces/test/collections' \
-H "X-Cassandra-Token: $AUTH_TOKEN" \
-H 'Content-Type: application/json'
Deleting a collection
Send a DELETE request to /v2/schemas/namespaces/test/collections/library to delete a namespace. All documents will be deleted along with the collection:
cURL command (/v2)
cURL command (/v1)
curl -L \
-X DELETE 'http://localhost:8180/v2/namespaces/test/collections/library' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json'
Deletions do not return any data.
Writing documents
All data written with the Document API is stored as JSON documents stored in collections.
A few terms will help your understanding as you prepare to write and read documents:
document-id
An ID that you can either assign as a string when creating a document, or a random UUID that is assigned if an ID is not assigned during document creation.
document-path
An endpoint (resource) that exposes your API, such as /book or /book/genre.
operation
An HTTP method used to manipulate the path, such as GET, POST, or DELETE.
For more information about the database design of the Document API, see the blog post on the Documents API.
Add document with a document-id
First, let’s add a document to a specified collection using a document-id. If a document-id is specified, a PUT request is required, rather than a POST request. The document-id can be any string. Send a PUT request to /v2/namespaces/{namespace_name}/collections/{collection_name}/{document-id} to add data to the collection library. The data is passed in the JSON body.
cURL command (/v2)
cURL command (/v1)
Result
curl --location \
--request PUT 'http://localhost:8180/v2/namespaces/test/collections/library/2545331a-aaad-45d2-b084-9da3d8f4c311' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data '{
  "stuff": "2545331a-aaad-45d2-b084-9da3d8f4c311",
  "other": "I need a document with a set value for a test."
}'
Notice that the document-id is returned.
Add a document without a document-id
Suppose you want each document to be assigned a random UUID. Send a POST request to /v2/namespaces/{namespace_name}/collections/{collections_name} to add data to the collection library. The data is passed in the JSON body.
cURL command (/v2)
cURL command (/v1)
Result
curl --location \
--request POST 'http://localhost:8180/v2/namespaces/test/collections/library' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data '{
  "id": "some-stuff",
  "other": "This is nonsensical stuff."
}'
Notice that the document-id returned is a UUID if not specified, by default.
Add a document with data
Documents can be added with varying JSON data, unless a JSON schema is specified. Send a POST request to /v2/namespaces/{namespace_name}/collections/{collections_name} similar to the last example, but add more JSON data to the body of the request:
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request POST 'http://localhost:8180/v2/namespaces/test/collections/library' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw ' {
    "reader": {
       "name": "Amy Smith",
       "user_id": "12345",
       "birthdate": "10-01-1980",
       "email": {
           "primary": "asmith@gmail.com",
           "secondary": "amyispolite@aol.com"
       },
       "address": {
           "primary": {
               "street": "200 Antigone St",
               "city": "Nevertown",
               "state": "MA",
               "zip-code": 55555
           },
           "secondary": {
               "street": "850 2nd St",
               "city": "Evertown",
               "state": "MA",
               "zip-code": 55556
           }
       },
       "reviews": [
           {
               "book-title": "Moby Dick", 
               "rating": 4, 
               "review-date": "04-25-2002",
               "comment": "It was better than I thought."
           },
           {
               "book-title": "Pride and Prejudice", 
               "rating": 2, 
               "review-date": "12-02-2002",
               "comment": "It was just like the movie."
           }
       ]
    }
}'
Note the difference between using POST and PUT. The POST request is used to insert new documents when you want the system to auto-generate the document-dd. The PUT request is used to insert a new document when you want to specify the document-id. These commands can also be used to update existing documents.
A 'PATCH' request using a document-id will replace the targeted data in a JSON object contained in the document. JSON objects are delimited by { } in the data. If you have an array, delimited by '[ ]' in the JSON object targeted, or a scalar value, the values will be overwritten.
Add another document (used in examples)
This document insertion is used in later examples. It is a PUT request:
Click to hide code
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request PUT 'http://localhost:8180/v2/namespaces/test/collections/library/native-son-doc-id' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw '     {
        "book": {
            "title": "Native Son",
            "isbn": "12322",
            "author": [
                "Richard Wright"
            ],
            "pub-year": 1930,
            "genre": [
                "poverty",
                "action"
            ],
            "format": [
                "hardback",
                "paperback",
                "epub"
            ],
            "languages": [
                "English",
                "German",
                "French"
            ]
        }
    }
'
Check a document with GET request
You are probably wondering how you get data back from a document. Let’s read the data from the last example with a GET request:
cURL command (/v2)
cURL command (/v1)
Result
curl -L \
-X GET 'http://localhost:8180/v2/namespaces/test/collections/library/native-son-doc-id' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json'
Add documents in a BATCH
It is often convenient to insert several documents into a collection with one request. The Document API has an endpoint that allows for batches of JSON documents to be inserted into the same collection. Data sent to the endpoint /v2/namespaces/{namespace_name}/collections/{collection_name}/batch is expected to be in JSON lines format (1 document per line). This feature was added with https://github.com/stargate/stargate/pull/1043.
More advanced use of batch
Click to hide code
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request POST 'http://localhost:8180/v2/namespaces/test/collections/library/batch' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw ' [{
     "reader": {
        "name": "Jane Doe",
        "user_id": "12345",
        "birthdate": "10-01-1980",
        "email": {
            "primary": "jdoe@gmail.com",
            "secondary": "jane.doe@aol.com"
        },
        "address": {
            "primary": {
                "street": "100 Main St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55555
            },
            "secondary": {
                "street": "850 2nd St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55556
            }
        },
        "reviews": [
            {
                "book-title": "Moby Dick", 
                "rating": 3, 
                "review-date": "02-02-2002",
                "comment": "It was okay."
            },
            {
                "book-title": "Pride and Prejudice", 
                "rating": 5, 
                "review-date": "03-02-2002",
                "comment": "It was a wonderful book! I loved reading it."
            }
        ]
     }
  },
  {
    "reader": {
       "name": "John Jones",
       "user_id": "54321",
       "birthdate": "06-11-2000",
       "email": {
           "primary": "jjones@gmail.com",
           "secondary": "johnnyj@aol.com"
       },
       "address": {
           "primary": {
               "street": "4593 Webster Ave",
               "city": "Paradise",
               "state": "CA",
               "zip-code": 95534
           }
       },
       "reviews": [
           {
               "book-title": "Moby Dick", 
               "rating": 2, 
               "review-date": "03-15-2020",
               "comment": "Boring book that I had to read for class."
           },
           {
               "book-title": "Pride and Prejudice", 
               "rating": 2, 
               "review-date": "0-02-2020",
               "comment": "Another boring book."
           }
       ]
    }
}
 ]'
Add more documents in a BATCH (used in examples)
Click to hide code
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request POST 'http://localhost:8180/v2/namespaces/test/collections/library/batch' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw ' [{
     "book": {
         "title": "Moby Dick",
         "isbn": "12345",
         "author": [
             "Herman Melville"
         ],
         "pub-year": 1899,
         "genre": [
             "adventure",
             "ocean",
             "action"
         ],
         "format": [
             "hardback",
             "paperback",
             "epub"
         ],
         "languages": [
             "English",
             "German",
             "French"
         ]
     }
    },
 {
     "book": {
         "title": "Pride and Prejudice",
         "isbn": "45674",
         "author": [
             "Jane Austen"
         ],
         "pub-year": 1890,
         "genre": [
             "romance",
             "England",
             "regency"
         ],
         "format": [
             "hardback",
             "paperback",
             "epub"
         ],
         "languages": [
             "English",
             "Japanese",
             "French"
         ]
     }
 },
     {
        "book": {
            "title": "The Art of French Cooking",
            "isbn": "19922",
            "author": [
                "Julia Child",
                "Simone Beck",
                "Louisette Bertholle"
            ],
            "pub-year": 1960,
            "genre": [
                "cooking",
                "French cuisine"
            ],
            "format": [
                "hardback",
                "paperback",
                "epub"
            ],
            "languages": [
                "English",
                "German",
                "French",
                "Belgian"
            ]
        }
    }
]'
Add a reader document with document-id [need in examples]
cURL command (/v2)
cURL command (/v1)
Result
curl --location --request PUT 'http://localhost:8180/v2/namespaces/test/collections/library/John-Smith' \
--header "X-Cassandra-Token: $AUTH_TOKEN" \
--header 'Content-Type: application/json' \
--data-raw '     {
     "reader": {
        "name": "John Smith",
        "user_id": "12346",
        "birthdate": "11-01-1992",
        "email": {
            "primary": "jsmith@gmail.com",
            "secondary": "john.smith@aol.com"
        },
        "address": {
            "primary": {
                "street": "200 Z St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55555
            },
            "secondary": {
                "street": "850 2nd St",
                "city": "Evertown",
                "state": "MA",
                "zip-code": 55556
            }
        },
        "reviews": [
            {
                "book-title": "Moby Dick", 
                "rating": 3, 
                "review-date": "02-02-2002",
                "comment": "It was okay."
            },
            {
                "book-title": "Pride and Prejudice", 
                "rating": 5, 
                "review-date": "03-02-2002",
                "comment": "It was a wonderful book! I loved reading it."
            }
        ]
     }
 }
'

## 3. Read documents

IF you know the ID of your document, it's easy to see what's there:

```
http  :/rest/v2/namespaces/library/collections/library/native-son-doc-id
```

But where is Fred?  I didn't write down his document ID!  You can get the Document ID for anything by querying the values in the document.

```
http GET :/rest/v2/namespaces/KS/collections/cavemen where=='{"firstname": { "$eq": "Fred"}}'
```

The "where" clause is really powerful, and allows you to combine different elements to really zero in on the document you want.

You can even get just a subset of the document by specifying a particular section in the path.

```
http :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble/firstname
```

and you can use "where" to specify a range of documents:

```
http GET :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble where:='{"lastname": {"$gt": "Flintstone"}}'
```

## 3. Update documents

So now we have Fred and Barney, but once again we haven't given Fred a job.  He just annoys Wilma when he hangs out at home, so that won't do at all.

Here's how you give Fred a job and get him out of Wilma's hair.  Remember, we just got his ID a few commands ago.  Let's grab it again and set it in the environment so we can use it as we like.

I'd like to give you a one-click way to set an env variable but alas, I think you will have to type a few characters into the terminal.

First, get your documentId.

```
http :/rest/v2/namespaces/KS/collections/cavemen where=='{"firstname": { "$eq": "Fred"}}'
```

Next, export that ID into your environment

```
export DOCUMENT_ID=
```
(paste the document ID and submit

Again, giving Fred a job. Wilma thanks you.

```
http PATCH :/rest/v2/namespaces/KS/collections/cavemen/$DOCUMENT_ID json:='{"firstname":"Fred","lastname":"flintstone","occupation":"Quarry Screamer"}'
```

So, how's Fred looking now?

```
http GET :/rest/v2/namespaces/KS/collections/cavemen/$DOCUMENT_ID
```

## 5. Delete the table

Not surprisingly, with this API, to delete a document you just, well, DELETE the document.

Let's go ahead and kick Barney out again.  He's gotta be used to it by now.

```
http DELETE :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble
```

But what if you're done with all the cavemen and want to clear out your documents?  This one is also really easy:

```
http DELETE :/rest/v2/namespaces/KS/collections/cavemen
```

Fantastic!  We've gone over all three of the API types.  Feel free to visit the developer site at https://datastax.com/dev to learn more about Cassandra, Astra and Stargate.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step4"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - GraphQL API
 </a>
  <a href='command:katapod.loadPage?[{"step":"finish"}]'
    class="btn btn-dark navigation-bottom-right">Finish
  </a>
</div>
