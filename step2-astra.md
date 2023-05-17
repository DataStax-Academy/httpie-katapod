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
 <a href='command:katapod.loadPage?[{"step":"step1-astra"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 2 of 3</span>
 <a href='command:katapod.loadPage?[{"step":"step3-astra"}]' 
    class="btn btn-dark navigation-top-right">Next
  </a>
</div>

<div class="step-title">Exploring Stargate APIs from the command line - REST Tables</div>

In this section you will use our httpie configuration to take a look at the Stargate REST API. We will focus on creating and retrieving a table.

- REST - List Keyspaces
- REST - Create a Table
- REST - Retrieve Tables

# 1. Create a table

The first thing that needs to happen is to create a table. HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "library" keyspace.

Here are the steps:

## A. Check for your keyspace

```
http :/rest/v2/schemas/keyspaces
```

Do you see 'library' in there? Great, we're ready to move on.

<details><summary>Show me the CQL</summary>
  
```
astra db cqlsh workshops -k library -e "desc keyspaces;"
```
  
</details>

You could also check for a specific keyspace:

```
http :/rest/v2/schemas/keyspaces/library
```

## B. Create the table

```
http POST :/rest/v2/schemas/keyspaces/library/tables json:='{
	"name": "users",
	"columnDefinitions":
	  [
        {
	      "name": "firstname",
	      "typeDefinition": "text"
	    },
        {
	      "name": "lastname",
	      "typeDefinition": "text"
	    },
        {
	      "name": "favorite color",
	      "typeDefinition": "text"
	    }
	  ],
	"primaryKey":
	  {
	    "partitionKey": ["firstname"],
	    "clusteringKey": ["lastname"]
	  },
	"tableOptions":
	  {
	    "defaultTimeToLive": 0,
	    "clusteringExpression":
	      [{ "column": "lastname", "order": "ASC" }]
	  }
}'
```

Just to be sure, go ahead and ask for a listing of the tables in the library keyspace:

```
http :/rest/v2/schemas/keyspaces/library/tables
```

<details><summary>Show me the CQL for this command</summary>
	
```
astra db cqlsh workshops -k library -e "desc tables;"
```

</details>

or specify the table you want:

```
http :/rest/v2/schemas/keyspaces/library/tables/users
```

<details><summary>Show me the CQL for this command</summary>
	
```
astra db cqlsh workshops -k library -e "desc users;"
```

</details>

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step1-astra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Create Astra DB
 </a>
 <a href='command:katapod.loadPage?[{"step":"step3-astra"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ REST Rows
  </a>
</div>
