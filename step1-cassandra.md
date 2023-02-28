
<!-- TOP -->
<div class="top">
  <img src="https://datastax-academy.github.io/katapod-shared-assets/images/ds-academy-logo.svg" />
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
<span class="step-count"> Step 1 of 5</span>
 <a href='command:katapod.loadPage?[{"step":"step2"}]' 
    class="btn btn-dark navigation-top-right">Next ➡️
  </a>
</div>

<!-- CONTENT -->

<div class="step-title">Start the Cassandra/Stargate Cluster</div>

✅ Start up the Cassandra cluster

This command can take a few minutes, please be patient.  It is:
* Starting a Cassandra Coordinator
* Starting up 3 Cassandra Nodes
* Starting Stargate nodes

```
git clone https://github.com/stargate/stargate
cd stargate/docker-compose/cassandra-4.0
./start_cass_40_dev_mode.sh
cp /workspace/httpie-katapod/assets/config-cassandra.json ~/.config/httpie/config.json
```

Again, please be patient.

## ✅ Create/Refresh your Token
Create a token to use for commands. This token will expire if you don't use it for 30 minutes, so you can return to this step to refresh the token.

```
export AUTH_TOKEN=`curl -L -X POST 'http://localhost:8081/v1/auth' \
  -H 'Content-Type: application/json' \
  --data-raw '{
    "username": "cassandra",
    "password": "cassandra"
}'| cut -f4 -d'"'`
http --session=stargate http://localhost:8082/v2/schemas/keyspaces  X-Cassandra-Token:$AUTH_TOKEN
ln -s ~/.config/httpie/sessions/localhost_8082 ~/.config/httpie/sessions/localhost_8080
ln -s ~/.config/httpie/sessions/localhost_8082 ~/.config/httpie/sessions/localhost_8081
```

✅ Create database keyspace `library`:
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
