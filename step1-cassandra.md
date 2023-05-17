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
 <a href='command:katapod.loadPage?[{"step":"step2-cassandra"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Start the Cassandra/Stargate Cluster</div>

✅ Start up the Cassandra cluster

This command can take a few minutes, please be patient. It is:

- Starting a Cassandra Coordinator
- Starting up 3 Cassandra Nodes
- Starting Stargate nodes

```
git clone https://github.com/stargate/stargate
cd stargate/docker-compose/cassandra-4.0
./start_cass_40_dev_mode.sh
cp /workspace/httpie-katapod/assets/config-cassandra.json ~/.config/httpie/config.json
```

Again, please be patient.

## ✅ Create/Refresh your Token

Create a token to use for commands. This token will expire if you don't use it for 30 minutes. Sometimes the servers can take a moment to fully come online, if you get an error when creating the token just click again to get a new one.

The future steps will refer back to this command, which you can use any time your token expires.

```
/workspace/httpie-katapod/token.sh
```

This sets a session in your httpie configuration which will be used whenever you make an HTTPie call.

✅ Create database keyspace `library` using the /schemas/keyspaces endpoint:

```
http POST http://localhost:8082/v2/schemas/keyspaces name=library
```

<!-- NAVIGATION -->
<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"intro"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - Intro
 </a>
 <a href='command:katapod.loadPage?[{"step":"step2-cassandra"}]'
    class="btn btn-dark navigation-bottom-right">Next ➡️ REST API
  </a>
</div>
