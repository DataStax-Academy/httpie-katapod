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
 <a href='command:katapod.loadPage?[{"step":"step2-astra"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 3 of 3</span>
 <a href='command:katapod.loadPage?[{"step":"finish-astra"}]' 
    class="btn btn-dark navigation-top-right">Next
  </a>
</div>

<!-- CONTENT -->
<div class="step-title">Exploring Stargate APIs from the command line - REST Rows</div>

In this section you will use our httpie configuration to take a look at the Stargate REST API. We will focus on creating and retrieving a table.

- REST - Create Rows
- REST - Read Rows
- REST - Update Rows
- REST - Delete Rows

## 1. Create rows

Great! The table is created. But it's kind of dull with no data. Go ahead and add a couple different rows with that data.

```
http POST :/rest/v2/keyspaces/library/users json:='
{
    "firstname": "Mookie",
    "lastname": "Betts",
    "favorite color": "blue"
}'
```

```
http POST :/rest/v2/keyspaces/library/users json:='
{
    "firstname": "Janesha",
    "lastname": "Doesha",
    "favorite color": "grey"
}'
```

Check to make sure they're really in there:

```
http :/rest/v2/keyspaces/library/users where=='{"firstname":{"$in":["Mookie","Janesha"]}}' -vvv
```

<details><summary>Show me the CQL</summary>
	
```
astra db cqlsh workshops -k library -e "select * from users where firstname IN ('Mookie', 'Janesha');"
```

</details>

## 3. Update the rows

```
http PUT :/rest/v2/keyspaces/library/users/Janesha/Doesha json:='{ "favorite color": "Fuchsia"}'
```

Check our work:

```
http :/rest/v2/keyspaces/library/users where=='{"firstname":{"$in":["Mookie","Janesha"]}}' -vvv
```

<details><summary>Show me the CQL</summary>
	
```
astra db cqlsh workshops -k library -e "select * from users where firstname IN ('Mookie', 'Janesha');"
```

</details>
	
## 4. Delete the rows

Janesha has moved away. Let's remove them from the database.

```
http DELETE :/rest/v2/keyspaces/library/users/Janesha/Doesha
```

So wait, are they gone?

```
http :/rest/v2/keyspaces/library/users/Janesha/Doesha
```

## 5. Delete the table

We don't need our table anymore, let's delete it.

```
http DELETE :/rest/v2/schemas/keyspaces/library/tables/users
```

Double checking - what tables are in my keyspace?

```
http :/rest/v2/schemas/keyspaces/library/tables
```

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step2-astra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back
 </a>
 <a href='command:katapod.loadPage?[{"step":"finish-astra"}]'
    class="btn btn-dark navigation-bottom-right">Finish
  </a>
</div>
