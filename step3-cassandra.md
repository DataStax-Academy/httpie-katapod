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
 <a href='command:katapod.loadPage?[{"step":"step2-cassandra"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 3 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step4-cassandra"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Exploring Stargate APIs from the command line - GraphQL (CQL First)</div>

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the GraphQL API

* GraphQL - Create a Table
* GraphQL - Add some rows
* GraphQL - Update the rows
* GraphQL - Delete the rows
* GraphQL - Delete the table

### 1. Create a table

The first thing that needs to happen is to create a table.  HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "Workshop" keyspace.

```
http POST localhost:8080/graphql-schema query='
mutation createTables {
  book: createTable(
    keyspaceName:"library",
    tableName:"book",
    partitionKeys: [ 
      { name: "title", type: {basic: TEXT} }
    ]
    clusteringKeys: [
      { name: "author", type: {basic: TEXT} }
    ]
  )
}'
```

If you need to add more attributes to something you are storing in a table, you can add one or more columns:
```
http POST localhost:8080/graphql-schema query='
mutation alterTableAddCols {
  alterTableAdd(
    keyspaceName:"library",
    tableName:"book",
    toAdd:[
      { name: "isbn", type: { basic: TEXT } }
      { name: "language", type: {basic: TEXT} }
      { name: "pub_year", type: {basic: INT} }
      { name: "genre", type: {basic:SET, info:{ subTypes: [ { basic: TEXT } ] } } }
      { name: "format", type: {basic:SET, info:{ subTypes: [ { basic: TEXT } ] } } }
    ]
  )
}'
```

To check how your tables are looking, execute a query to see them:
```
http POST localhost:8080/graphql-schema query='
query GetTables {
  keyspace(name: "library") {
      name
      tables {
          name
          columns {
              name
              kind
              type {
                  basic
                  info {
                      name
                  }
              }
          }
      }
  }
}'
```


## 2. Add some rows
You can insert rows one at a time, or use a command like this to create two rows at once.

```
http POST localhost:8080/graphql/library query='
mutation insert2Books {
  moby: insertbook(value: {title:"Moby Dick", author:"Herman Melville"}) {
    value {
      title
    }
  }
  catch22: insertbook(value: {title:"Catch-22", author:"Joseph Heller"}) {
    value {
      title
    }
  }
}'
```



## 3. Retrieve the rows

Get one book using the primary key title with a value

```
http POST localhost:8080/graphql/library query=' 
query oneBook {
    book (value: {title:"Moby Dick"}) {
      values {
      	title
      	author
      }
    }
}'
```

To find multiple books, an addition to the WHERE clause is required, to denote that the list of titles desired is IN a group:


```
http POST localhost:8080/graphql/library query='
query ThreeBooks {
  book(filter: { title: { in: ["Native Son", "Moby Dick", "Catch-22"] } } ) {
      values {
      	title
	author
     }
   }
}'
```

Now you can move on and check out the Document API.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step2-cassandra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - REST API
 </a>
 <a href='command:katapod.loadPage?[{"step":"step4-cassandra"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ Document API
  </a>
</div>
