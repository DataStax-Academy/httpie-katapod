<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-2023.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Exploring Stargate with HTTPie</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:kirsten.hunter@datastax.com">email</a> or <a href="https://linkedin.com/in/synedra">LinkedIn</a>.</span>
  </div>
</div>


<!-- NAVIGATION -->
<div id="navigation-top" class="navigation-top">
 <a href='command:katapod.loadPage?[{"step":"step4-astra"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 5 of 5</span>
 <a href='command:katapod.loadPage?[{"step":"finish-astra"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Exploring Stargate APIs from the command line - Document API</div>

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the Document API.  This API deserves a little more explanation, as it is not what you might think of as a standard Cassandra database.  In this API, you give the database JSON objects and can then work with them based on their contents.  This database model doesn't require a schema, it just has the documents you put in there, which are placed in collections that you define.

* Document - Create a Collection
* Document - Write Documents
* Document - Read documents
* Document - Update documents
* Document - Delete document

## 1. Create a collection

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
  "other": "I do not care much about the ID for this document."
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




Add a reader document with a specific document ID:

```
http PUT :/rest/v2/namespaces/library/collections/library/John-Smith query:='     {
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
```

## 3. Read Documents

You can either search in collections for documents, or you can search within documents.

*List all documents in a collection*
This command finds all the documents that exist in a collection.

```
http :/rest/v2/namespaces/library/collections/library
```

*Decorations for getting documents - paging-size, paging-state, fields*

Paging Size - The page-size parameter has a default value of 3 and a maximum value of 20. 

```
http :/rest/v2/namespaces/library/collections/library?page-size=1
```

Page State: When there are more documents than the page-size, the API will return a pageState.  This value can be used to get the next "batch" of documents.  Note, you receive it as pageState but it must be sent as page-state

Fields: By default you get all of the fields.  Using the fields parameter allows you to select which parts of the data you want to receive.

```
http :/rest/v2/namespaces/library/collections/library/native-son-doc-id?fields='["book.title","book.genre"]'
```

*Search collection for documents with a simple WHERE clause*

```
http :/rest/v2/namespaces/library/collections/library?where='{"reader.name":{"$eq":"Amy%20Smith"}}'
```

If you want more details, check out the [Stargate Documentation](https://stargate.io/docs/latest/develop/dev-with-doc.html#search-collections-for-documents-with-operators-eq-ne-or-and-not-gt-gte-lt-lte-in-nin) for the Document API

## 4. Update Documents

The easiest way to update a document is to use PUT to replace it:

```
http PUT :/rest/v2/namespaces/library/collections/library/long-ID-number json:='
{
  "stuff": "long-ID-number",
  "other": "Changed information in the doc."
}'
```

Get that document to make sure the changes happened:

```
http :/rest/v2/namespaces/library/collections/library/long-ID-number
```

A 'PATCH' request using a document-id will replace the targeted data in a JSON object contained in the document. JSON objects are delimited by { } in the data. If you have an array, delimited by '[ ]' in the JSON object targeted, or a scalar value, the values will be overwritten.

```
http PATCH :/rest/v2/namespaces/library/collections/library/long-ID-number json:='
{
  "newfield": "Hope I kept my existing fields!"
}'
```

Check out the results:

```
http :/rest/v2/namespaces/library/collections/library/long-ID-number
```

Another example using an array:

```
http PATCH :/rest/v2/namespaces/library/collections/library/long-ID-number json:='
{
  "yet-another-field": "Hopefully, I did not lose my other two fields!",
  "languages": [
     "English",
     "German",
     "French"
  ]
}'
```

And grab that document again:

```
http :/rest/v2/namespaces/library/collections/library/long-ID-number
```

It is also possible to update only part of a document. Using a PUT request, you can replace current data in a document. To partially update, send a PUT request to /v2/namespaces/{namespace_name}/collections/{collections_name}/{document-id}/{document-path}. This example will replace the book sub-object with just the title of "Native Daughter."

```
http PUT :/rest/v2/namespaces/library/collections/library/native-son-doc-id/book json:='
{ "title": "Native Daughter" }'
```

Check the results:
```
http :/rest/v2/namespaces/library/collections/library/native-son-doc-id
```

Using a PATCH request, you can overwrite current data in a document. To partially update, send a PATCH request to /v2/namespaces/{namespace_name}/collections/{collections_name}/{document-id}/{document-path}. This example overwrites a book’s information:

```
http PATCH :/rest/v2/namespaces/library/collections/library/native-son-doc-id json:='
{
  "book": {
    "title": "Native Daughter",
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
}'
```

Check the results:

```
http :/rest/v2/namespaces/library/collections/library/native-son-doc-id
```

And delete the collection:

```
http DELETE :/rest/v2/namespaces/library/collections/library
```

Fantastic!  We've gone over all three of the API types.  Feel free to visit the developer site at https://datastax.com/dev to learn more about Cassandra, Astra and Stargate.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step4-astra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - GraphQL API
 </a>
  <a href='command:katapod.loadPage?[{"step":"finish-astra"}]'
    class="btn btn-dark navigation-bottom-right">Finish
  </a>
</div>
