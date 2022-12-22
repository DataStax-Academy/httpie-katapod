<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
  <div class="scenario-title-section">
    <span class="scenario-title">Exploring Stargate with HTTPie</span>
    <span class="scenario-subtitle">ℹ️ For technical support, please contact us via <a href="mailto:kirsten.hunter@datastax.com">email</a> or <a href="https://linkedin.com/in/synedra">LinkedIn</a>.</span>
  </div>
</div>

<div class="step-title">HTTPie and Credentials</div>

**Objectives**
In this step, we will:
1. Install HTTPie
2. Verify Credentials

---

# 1. Install HTTPie
HTTPie is an excellent API CLI tool, which we've extended to understand the astra authentication model.  

```
pip3 install httpie-astra
```

# 2. Create the credentials file

```
astra db create-dotenv -k workshop stargate
```

Now let's copy those credentials to our environment

```
echo "[default]" > ~/.astrarc
cat .env | tr -d \" >> ~/.astrarc
```

## 3. Verify Credentials

Make a call to the API using httpie to make sure your credentials are working:

```
http --auth-type astra -a default: :/rest/v1/keyspaces
```

We've actually got an httpie config file so we can skip the auth-type stuff.

Try the simpler call to make sure it works:

```
http :/rest/v1/keyspaces
```

Great, it's time to dive deeper into the Stargate APIs to see what they can do for you.

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step1"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Create Astra DB
 </a>
 <a href='command:katapod.loadPage?[{"step":"step3"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ REST API
  </a>
</div>
