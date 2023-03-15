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
 <a href='command:katapod.loadPage?[{"step":"step1-cassandra"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 2 of 4</span>
 <a href='command:katapod.loadPage?[{"step":"step3-cassandra"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Exploring Stargate APIs from the command line - REST</div>

In this section you will use our httpie configuration to take a look at the Stargate REST API. 

- REST - Create a Table
- REST - Add some rows
- REST - Update the rows
- REST - Delete the rows
- REST - Delete the table

*Did your token expire?  Reset it with this command.*

```
/workspace/httpie-katapod/token.sh
```

## 1. Create a table

The first thing that needs to happen is to create a table. HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "library" keyspace.

Here are the steps:

#### A. Check for your keyspace


```
http http://localhost:8082/v2/schemas/keyspaces
```

Do you see 'library' in there? Great, we're ready to move on. 


You could also check for a specific keyspace:


```
http http://localhost:8082/v2/schemas/keyspaces/library
```

#### B. Create the tables


```
echo -n '{
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
}' | http POST localhost:8082/v2/schemas/keyspaces/library/tables
```

Just to be sure, go ahead and ask for a listing of the tables in the library keyspace:

```
http localhost:8082/v2/schemas/keyspaces/library/tables
```

or specify the table you want:
```
http localhost:8082/v2/schemas/keyspaces/library/tables/users
```

## 2. Add some rows

Great! The table is created. But it's kind of dull with no data. Go ahead and add a couple different rows with that data.

```
echo -n '
{
    "firstname": "Mookie",
    "lastname": "Betts",
    "favorite color": "blue"
}' | http POST localhost:8082/v2/keyspaces/library/users
```

```
echo -n '
{
    "firstname": "Janesha",
    "lastname": "Doesha",
    "favorite color": "grey"
}' | http POST localhost:8082/v2/keyspaces/library/users
```

Check to make sure they're really in there:

```
http localhost:8082/v2/keyspaces/library/users where=='{"firstname":{"$in":["Mookie","Janesha"]}}' -vvv
```

## 3. Update the rows

```
http PUT localhost:8082/v2/keyspaces/library/users/Janesha/Doesha "favorite color"=Fuchsia
```

Check our work:

```
http localhost:8082/v2/keyspaces/library/users where=='{"firstname":{"$in":["Mookie","Janesha"]}}' -vvv
```

## 4. Delete the rows

Janesha has moved away.  Let's remove them from the database.

```
http DELETE localhost:8082/v2/keyspaces/library/users/Janesha/Doesha
```

So wait, are they gone?

```
http localhost:8082/v2/keyspaces/library/users/Janesha/Doesha
```

## 5. Delete the table

We don't need our table anymore, let's delete it.

```
http DELETE localhost:8082/v2/schemas/keyspaces/library/tables/users
```

Double checking - what tables are in my keyspace?

```
http localhost:8082/v2/schemas/keyspaces/library/tables
```

Now you can move on and check out the GraphQL API.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step1-cassandra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Credentials
 </a>
 <a href='command:katapod.loadPage?[{"step":"step3-cassandra"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ GraphQL API
  </a>
</div>
