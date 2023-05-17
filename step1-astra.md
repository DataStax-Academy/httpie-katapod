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
 <a href='command:katapod.loadPage?[{"step":"intro"}]' 
   class="btn btn-dark navigation-top-left">⬅️ Back
 </a>
<span class="step-count"> Step 1 of 3</span>
 <a href='command:katapod.loadPage?[{"step":"step2-astra"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Connect to Astra DB and create a database</div>

**Objectives**
In this step we will

1. Create token
2. Create database
3. Create Credentials
4. Verify Credentials

# 1. Create the token

✅ Create an application token with the _Database Administrator_ role to access Astra DB. Skip this step if you already have a token.

<ul>
  <li>Sign in (or sign up) to your Astra account at <a href="https://astra.datastax.com?utm_source=awesome-astra&utm_medium=social_organic&utm_campaign=httpie-katapod&utm_term=all-plays&utm_content=register">astra.datastax.com</a></li>
  <li>Create an application token with the <i>Database Administrator</i> role by following <a href="https://awesome-astra.github.io/docs/pages/astra/create-token/" target="_blank">these instructions</a></li>
</ul>

# 2. Create the database

✅ Setup Astra CLI by providing the Database Administrator application token you created <a href="https://awesome-astra.github.io/docs/pages/astra/create-token/" target="_blank">here</a>:

```
astra setup
```

✅ Create database `workshops` and keyspace `library` if they do not exist:

```
astra db create workshops -k library --if-not-exist --wait
```

This operation may take a bit longer when creating a new database or resuming an existing hibernated database.

✅ Verify that database `workshops` is `ACTIVE` and keyspace `library` exists:

```
astra db get workshops
```

If the command fails, please revisit the previous steps to make sure that the database exists and is `ACTIVE`, and retry connecting to the database again.

<div class="step-title">HTTPie and Credentials</div>

---

# 3. Create the credentials file

```
astra db create-dotenv -k library workshops
```

Now let's copy those credentials to our environment

```
echo "[workshops]" >> ~/.astrarc
cat .env | tr -d \" >> ~/.astrarc
cp /workspace/httpie-katapod/assets/config-astra.json ~/.config/httpie/config.json
```

## 4. Verify Credentials

Make a call to the API using httpie to make sure your credentials are working:

```
http --auth-type astra -a workshops: :/rest/v1/keyspaces
```

We've actually got an httpie config file so we can skip the auth-type stuff.

Try the simpler call to make sure it works:

```
http :/rest/v1/keyspaces
```

<details><summary>Show me the CQL</summary>
  
```
astra db cqlsh workshops -k library -e "desc keyspaces;"
```
  
</details>

Great, it's time to dive deeper into the Stargate APIs to see what they can do for you.

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"intro"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Overview
 </a>
 <a href='command:katapod.loadPage?[{"step":"step2-astra"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ Tables in the REST API
  </a>
</div>
