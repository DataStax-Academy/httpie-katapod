<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Exploring Stargate with HTTPie</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:kirsten.hunter@datastax.com">email</a> or <a href="https://linkedin.com/in/synedra">LinkedIn</a>.</span>
  </div>
</div>

# Exploring Stargate APIs from the command line - GraphQL (CQL First)

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the GraphQL API

* GraphQL - Create a Table
* GraphQL - Add some rows
* GraphQL - Update the rows
* GraphQL - Delete the rows
* GraphQL - Delete the table

### 0. Create a UDT (User Defined Type)

Cassandra provides User Defined Types for you to keep your data organized more efficiently and tidy up your table definitions.

```
http POST :/graphql-schema query='
mutation createAddressUDT {
  createType(
    keyspaceName: "library"
    typeName: "address_type"
    fields: [
      { name: "street", type: { basic: TEXT } }
      { name: "city", type: { basic: TEXT } }
      { name: "state", type: { basic: TEXT } }
      { name: "zip", type: { basic: TEXT } }
    ]
  )
}'
```

### 1. Create a table

The first thing that needs to happen is to create a table.  HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "Workshop" keyspace.

```
http POST :/graphql-schema query='
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
  reader: createTable(
    keyspaceName:"library",
    tableName:"reader",
    partitionKeys: [
      { name: "name", type: {basic: TEXT} }
    ]
    clusteringKeys: [ 
      { name: "user_id", type: {basic: UUID}, order: "ASC" }
  	]
    values: [
      { name: "birthdate", type: {basic: DATE} }
      { name: "email", type: {basic: SET, info:{ subTypes: [ { basic: TEXT } ] } } }
      { name: "reviews", type: {basic: TUPLE, info: { subTypes: [ { basic: TEXT }, { basic: INT }, { basic: DATE } ] } } }
      { name: "addresses", type: { basic: LIST, info: { subTypes: [ { basic: UDT, info: { name: "address_type", frozen: true } } ] } } }
    ]
  )
}'
```

Just to be sure, go ahead and ask for a listing of the tables in the Workshop keyspace:

```
http :/rest/v2/schemas/keyspaces/library/tables
```

If you need to add more attributes to something you are storing in a table, you can add one or more columns:
```
http POST :/graphql-schema query='
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
http POST :/graphql-schema query='
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
http POST :/graphql/library query='
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

Inserting lists is easy, give a command like this one:

```
# insert an article USING A LIST (authors)
http POST :/graphql/library query='
mutation insertArticle {
  magarticle: insertarticle(value: {title:"How to use GraphQL", authors: ["First author", "Second author"], mtitle:"Database Magazine"}) {
    value {
      title
      mtitle
      authors
    }
  }
}'
```

A map is a little more complex.

```
http POST :/graphql/library query='
mutation insertOneBadge {
  gold: insertBadges(value: { btype:"Gold", earned: "2020-11-20", category: ["Editor", "Writer"] } ) {
    value {
      btype
      earned
      category
    }
  }
}'
```

Using a UDT requires that you be very specific about your terms.

```
http POST :/graphql/library query='
mutation insertReaderWithUDT{
  ag: insertreader(
    value: {
      user_id: "e0ed81c3-0826-473e-be05-7de4b4592f64"
      name: "Allen Ginsberg"
      birthdate: "1926-06-03"
      addresses: [{ street: "Haight St", city: "San Francisco", zip: "94016" }]
    }
  ) {
    value {
      user_id
      name
      birthdate
      addresses {
        street
        city
        zip
      }
    }
  }
 }'
 ```

## 3. Retrieve the rows

Get one book using the primary key title with a value

```
http POST :/graphql/workshop query=' 
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
http POST :/graphql/workshop query='
    query cavemen {
    cavemen(filter: {lastname: {in: ["Rubble", "Flintstone"]}}) {
    values {firstname
    lastname
    occupation}
}}'
```

```
http POST :/graphql/workshop query='
query ThreeBooks {
  book(filter: { title: { in: ["Native Son", "Moby Dick", "Catch-22"] } } ) {
      values {
      	title
	author
     }
   }
}'
```

To display the contents of a UDT, notice the inclusion of addresses in the values displayed for this read query:

```
http POST :/graphql/workshop query='
query getReaderWithUDT{
  reader(value: { name:"Allen Ginsberg" user_id: "e0ed81c3-0826-473e-be05-7de4b4592f64" }) {
    values {
      name
      birthdate
      addresses {
        street
        city
        zip
      }
    }
  }
}'
```

To display the contents of a map collection, notice the inclusion of earned in the values displayed for this read query:
```
http POST :/graphql/workshop query='
query oneGoldBadge {
  badge(value: { badge_type: "Gold" } ) {
      values {
      	badge_type
        badge_id
        earned {
        key
        value
      }
     }
  }
}'
```

## 4. Delete

Delete columns from table schema
If you find an attribute is no longer required in a table, you can remove a column. All column data will be deleted along with the column schema.

```
http POST :/graphql/workshop query='
mutation dropColumnFormat {
    alterTableDrop(
    keyspaceName:"library",
    tableName:"book",
    toDrop:["format"]
  )
}'
```

You can delete a table. All data will be deleted along with the table schema.

```
http POST :/graphql/workshop query='
mutation dropTableBook {
  dropTable(keyspaceName:"library",
    tableName:"article")
}'
```


Now you can move on and check out the Document API.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - REST API
 </a>
 <a href='command:katapod.loadPage?[{"step":"step4"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ Document API
  </a>
</div>
