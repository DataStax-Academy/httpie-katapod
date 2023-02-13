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

* Document - Create a Collection
* Document - Write Documents
* Document - Read documents
* Document - Update documents
* Document - Delete document

### 1. Create a collection

You'll need a collection to hold your documents.  This is separate from the database name (we're using workshops) or namespace (in this case, library) that contains it.  If you don't create the collection, it will automatically be created for you when you insert your first document.

```
http POST :/rest/v2/namespaces/library/collections json:='{"name":"library"}'
```

Check to make sure that it got created:

```
http :/rest/v2/namespaces/library/collections
```

## 2. Write a document

Create a document without specifying the ID 

```
http POST :/rest/v2/namespaces/library/collections/library json:='
{
  "stuff": "Random ramblings",
  "other": "I don't care much about the ID for this document."
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

```
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
```

Note the difference between using POST and PUT. The POST request is used to insert new documents when you want the system to auto-generate the document-dd. The PUT request is used to insert a new document when you want to specify the document-id.

Here's a document we'll use in later examples, PUT with a specific ID.

```
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
```

It is often convenient to insert several documents into a collection with one request. The Document API has an endpoint that allows for batches of JSON documents to be inserted into the same collection. 

```
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
```

This batch has documents we'll use in later examples:

```
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
```

Add a reader document with a specific document ID:

```
http PUT :/rest/v2/namespaces/library/collections/library/John-Smith' query:='     {
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

### 3. Read Documents

You can either search in collections for documents, or you can search within documents.

*List all documents in a collection*
This command finds all the documents that exist in a collection.

```
http :/rest/v2/namespaces/library/collections/library
```

*Decorations for getting documents - paging-size, paging-state, fields*

Paging Size - The page-size parameter has a default value of 3 and a maximum value of 20. 

```
http :/rest/v2/namespaces/library/collections/library?page-size=5
```

Page State
When there are more documents than the page-size, the API will return a pageState.  This value can be used to get the next "batch" of documents.  Note, you receive it as pageState but it must be sent as page-state

You can try this by copying the pageState from the previous call, updating it and running the command again.
http :/rest/v2/namespaces/library/collections/library?page-state=JGQwODFlYmIyLTQ4OWUtNDI1ZS04NTI1LWEyNTU4NGY0N2JjZADwf_____B_____

Fields
By default you get all of the fields.  Using the fields parameter allows you to select which parts of the data you want to receive.

```
http :/rest/v2/namespaces/library/collections/library/native-son-doc-id?fields=["book.title","book.genre"]
```

*Search collection for documents with a simple WHERE clause*

```
http :/rest/v2/namespaces/library/collections/library?where={"reader.name":{"$eq":"Amy%20Smith"}}
```

*Search collection for documents with a simple WHERE clause with fields*

Putting it all together:

```
http :/rest/v2/namespaces/library/collections/library?where={"reader.name":{"$eq":"Amy%20Smith"}}&fields=["reader.name","reader.birthdate"]

If you want more details, check out the [Stargate Documentation](https://stargate.io/docs/latest/develop/dev-with-doc.html#search-collections-for-documents-with-operators-eq-ne-or-and-not-gt-gte-lt-lte-in-nin) for the Document API

4. Update Documents

Fantastic!  We've gone over all three of the API types.  Feel free to visit the developer site at https://datastax.com/dev to learn more about Cassandra, Astra and Stargate.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step4"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - GraphQL API
 </a>
  <a href='command:katapod.loadPage?[{"step":"finish"}]'
    class="btn btn-dark navigation-bottom-right">Finish
  </a>
</div>
