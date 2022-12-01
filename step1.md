# ⚒️ Create your Astra instance
### Exercise time: _~10 minutes_

**Objectives**

In this step, we will:
- Create an Astra database to store data

**We will cover:**

1. Register and Sign In to Astra
2. Configure and create your database
3. Let Astra Start Up

One of the first things we need to do is hook up the "plumbing" of our application to talk to our back-end services, namely, our Cassandra database with **Astra**. Once this is in place, we are connected and ready to go with the services we need to power our app.

We will be making use of the Document API and REST API to connect to our **Astra** database. The **Stargate** API framework allows developers the freedom to access **Astra** with a variety of APIs.  The REST and GraphQL APIs make it easy to interact with standard Cassandra databases. **With the Document API, you can save and search schemaless JSON documents in Cassandra**. No need to use SQL, CQL, or any database drivers to talk to the data layer. Just code and move on.

_ahem...for those of you familiar with Apache Cassandra, yes, I just said you could skip data modeling._

![Document API Flow](https://github.com/DataStax-Examples/battlestax/blob/master/tutorial/document-api.png?raw=true)

### 1. Register and Sign In to Astra

The `ASTRA` service is available at url [https://astra.datastax.com](https://dtsx.io/workshop). `ASTRA` is the simplest way to run Cassandra with zero operations at all - just push the button and get your cluster. `Astra` offers $25 credit/month and requires no credit card to setup.  That $25 gives you a lot of storage space and transactions, and you have no worries of being accidentally charged.

### ✅ Step 1a. Use the dialogs to create an account and/or sign in
You can use your `Github`, `Google` accounts or register with an `email`.

Make sure to chose a password with minimum 8 characters, containing upper and lowercase letters, at least one number and special character
- [Registration Page](https://dtsx.io/workshop)

![Registration Image](https://github.com/DataStax-Examples/battlestax/blob/master/tutorial/login-1000.png?raw=true)

### 2. Configure and create your database
✅ 1. All of our databases are now serverless, so just click "Create Database" in the left pane and you're good to go.

✅ 2. **Choose your plan:** The "Pay as You Go" plan gives you $25/month of traffic and storage, and does not require a credit card - if you get close to the limit we'll let you know.  Click "Get Started."

✅ 3. **Name your Database:** With our new serverless plan you can have as many databases as you need.  For this workshop, use "node-stargate" as the database name and "workshop" as the Keyspace name.
![image](https://user-images.githubusercontent.com/77410784/112509456-b72b5280-8d4d-11eb-8d6f-ed93c4ad55da.png)

✅ 4. **Select a cloud provider:** You can use either GCP or AWS.  Chose a region that's geographically close to you.

✅ 5. **Click `Create Database`**

### 3. Let Astra Start Up
Honestly, there's not much to do here, but wait a couple minutes for your Astra database to start up. Once completed, you will have a fully managed Apache Cassandra database ready to rock and power your app.

You will see your new database `Pending` or `Initializing` in the Dashboard.
<img width="919" alt="image" src="https://user-images.githubusercontent.com/77410784/111340767-28745280-8636-11eb-81a6-bcfcea4e1d18.png">

The status will change to `Active` when the database is ready, this will only take 2-3 minutes and you will also receive an email when it is ready.

#### Awesome! While you are waiting for your database to startup feel free to move to the next section.
