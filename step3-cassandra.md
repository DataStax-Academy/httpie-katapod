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
<span class="step-count"> Step 3 of 3</span>
 <a href='command:katapod.loadPage?[{"step":"finish-cassandra"}]' 
    class="btn btn-dark navigation-top-right">Finish
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Exploring Stargate APIs from the command line - REST</div>

In this section you will use our httpie configuration to take a look at the Stargate REST API.

- REST - Create Rows
- REST - Read Rows
- REST - Update Rows
- REST - Delete Rows

_Did your token expire? Reset it with this command._

```
/workspace/httpie-katapod/token.sh
```

## 1. Add some rows

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

## 2. Update the rows

```
http PUT localhost:8082/v2/keyspaces/library/users/Janesha/Doesha "favorite color"=Fuchsia
```

Check our work:

```
http localhost:8082/v2/keyspaces/library/users where=='{"firstname":{"$in":["Mookie","Janesha"]}}' -vvv
```

## 3. Delete the rows

Janesha has moved away. Let's remove them from the database.

```
http DELETE localhost:8082/v2/keyspaces/library/users/Janesha/Doesha
```

So wait, are they gone?

```
http localhost:8082/v2/keyspaces/library/users/Janesha/Doesha
```

## 4. Delete the table

We don't need our table anymore, let's delete it.

```
http DELETE localhost:8082/v2/schemas/keyspaces/library/tables/users
```

Double checking - what tables are in my keyspace?

```
http localhost:8082/v2/schemas/keyspaces/library/tables
```

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step2-cassandra"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Credentials
 </a>
 <a href='command:katapod.loadPage?[{"step":"finish-cassandra"}]'
    class="btn btn-dark navigation-bottom-right" onClick="alert('Hello, world!')">Finish
  </a>
</div>
