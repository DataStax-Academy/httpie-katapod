<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Exploring Stargate with HTTPie</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:kirsten.hunter@datastax.com">email</a> or <a href="https://linkedin.com/in/synedra">LinkedIn</a>.</span>
  </div>
</div>

# Exploring Stargate APIs from the command line - GraphQL

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the GraphQL API

* GraphQL - Create a Table
* GraphQL - Add some rows
* GraphQL - Update the rows
* GraphQL - Delete the rows
* GraphQL - Delete the table

### 1. Create a table

The first thing that needs to happen is to create a table.  HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "Workshop" keyspace.

```
http POST :/graphql-schema query='
mutation createTables {
    cavemen: createTable(
        keyspaceName: "workshop", 
        tableName: "cavemen", 
        partitionKeys: 
            [{name: "lastname", type: {basic: TEXT}}], 
        clusteringKeys: 
            [{name: "firstname", type: {basic: TEXT}}],
        values: [
            { name: "occupation", type: {basic: TEXT} }
        ]
)}'
```

Just to be sure, go ahead and ask for a listing of the tables in the Workshop keyspace:

```
http :/rest/v2/schemas/keyspaces/workshop/tables
```

## 2. Add some rows
Great!  The table is created.  But it's kind of dull with no data.  Since it's looking for firstname and lastname, add a couple different rows with that data.

```
http POST :/graphql/workshop query='
mutation insertcavemen {
  barney: insertcavemen(value: {firstname:"Barney", lastname: "Rubble"}) {
    value {
      firstname
    }
  }
}'
```

```
http POST :/graphql/workshop query='
mutation insertcavemen {
  fred: insertcavemen(value: {firstname:"Fred", lastname: "Flintstone"}) {
    value {
      firstname
    }
  }
}'
```

Check to make sure Barney's really in there:

```
http POST :/graphql/workshop query='
query getCaveman {
    cavemen (value: {lastname:"Rubble"}) {
      values {
      	lastname
      }
    }
}'
```

## 3. Update the rows

Again, giving Fred a job.

```
http POST :/graphql/workshop query='
mutation updatecavemen {
  fred: updatecavemen(value: {firstname:"Fred",lastname:"Flintstone",occupation:"Quarry Screamer"}, ifExists: true ) {
    value {
      firstname
    }
  }
}'
```

Check our work:

```
http POST :/graphql/workshop query='
    query cavemen {
    cavemen(filter: {lastname: {in: ["Rubble", "Flintstone"]}}) {
    values {firstname
    lastname
    occupation}
}}'
```

## 4. Delete the rows

Barney's not really adding a lot of value.  Let's kick him out:

```
http POST :/graphql/workshop query='
mutation deletecavemen {
  barney: deletecavemen(value: {firstname:"Barney",lastname:"Rubble"}, ifExists: true ) {
    value {
      firstname
    }
  }
}'
```

So wait, is he gone?

```
http POST :/graphql/workshop query='
    query cavemen {
    cavemen(filter: {lastname: {in: ["Rubble", "Flintstone"]}}) {
    values {firstname}
}}'
```

## 5. Delete the table

We don't need our table anymore, let's delete it.  We need to use the REST API for this.

```
http DELETE :/rest/v2/schemas/keyspaces/workshop/tables/cavemen
```

Double checking - what tables are in my keyspace?

```
http :/rest/v2/schemas/keyspaces/workshop/tables
```

Now you can move on and check out the Document API.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - REST API
 </a>
 <a href='command:katapod.loadPage?[{"step":"step5"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ Document API
  </a>
</div>
