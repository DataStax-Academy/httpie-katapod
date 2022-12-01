# Exploring Stargate APIs from the command line - REST

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the REST API

* REST - Create a Table
* REST - Add some rows
* REST - Update the rows
* REST - Delete the rows
* REST - Delete the table

### 1. Create a table

The first thing that needs to happen is to create a table.  HTTPie will handle the authentication and create the right server based on your .astrarc file, but you'll need to make sure and use that "Workshop" keyspace.

`http POST :/rest/v2/schemas/keyspaces/workshop/tables json:='{
  "name": "cavemen",
  "ifNotExists": false,
  "columnDefinitions": [
    {
      "name": "firstname",
      "typeDefinition": "text",
      "static": false
    },
    {
      "name": "lastname",
      "typeDefinition": "text",
      "static": false
    },
        {
	      "name": "occupation",
	      "typeDefinition": "text"
	    }
  ],
  "primaryKey": {
    "partitionKey": [
      "lastname"
    ],
    "clusteringKey": [
      "firstname"
    ]
  }
}'`{{execute}}

Just to be sure, go ahead and ask for a listing of the tables in the Workshop keyspace:

`http :/rest/v2/schemas/keyspaces/workshop/tables`{{execute}}

## 2. Add some rows
Great!  The table is created.  But it's kind of dull with no data.  Since it's looking for firstname and lastname, add a couple different rows with that data.

`http POST :/rest/v2/keyspaces/workshop/cavemen json:='
{
            "firstname" : "Fred",
            "lastname": "Flintstone"
}'`{{execute}}

`http POST :/rest/v2/keyspaces/workshop/cavemen json:='
{
            "firstname" : "Barney",
            "lastname": "Rubble"
}'`{{execute}}

Check to make sure they're really in there:
`http :/rest/v2/keyspaces/workshop/cavemen where=='{"lastname":{"$in":["Rubble","Flintstone"]}}' -vvv`{{execute}}

## 3. Update the rows

`http PUT :/rest/v2/keyspaces/workshop/cavemen/Flintstone/Fred json:='
{ "occupation": "Quarry Screamer"}'`{{execute}}

Check our work:
`http :/rest/v2/keyspaces/workshop/cavemen where=='{"lastname":{"$in":["Rubble","Flintstone"]}}' -vvv`{{execute}}

## 4. Delete the rows

Barney's not really adding a lot of value.  Let's kick him out:
`http DELETE :/rest/v2/keyspaces/workshop/cavemen/Rubble/Barney`{{execute}}

So wait, is he gone?

`http :/rest/v2/keyspaces/workshop/cavemen/Rubble/Barney`{{execute}}

## 5. Delete the table

We don't need our table anymore, let's delete it.

`http DELETE :/rest/v2/schemas/keyspaces/workshop/tables/cavemen`{{execute}}

Double checking - what tables are in my keyspace?

`http :/rest/v2/schemas/keyspaces/workshop/tables`{{execute}}

Now you can move on and check out the GraphQL API.