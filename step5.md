# Exploring Stargate APIs from the command line - Document API

In this section you will use our httpie configuration to take a look at the Stargate APIs.  In this section we will use the Document API.  This API deserves a little more explanation, as it is not what you might think of as a standard Cassandra database.  In this API, you give the database JSON objects and can then work with them based on their contents.  This database model doesn't require a schema, it just has the documents you put in there, which are placed in collections that you define.

* Document - Choose a Namespace
* Document - Write a Document
* Document - Read documents
* Document - Update documents
* Document - Delete document

### 1. Choose a namespace

Before you get started, you'll need to grab a list of your namespaces in order to figure out the right path to use.

`http :/rest/v2/schemas/namespaces | jq ".data[].name"`{{execute}}

Hey, look!  There's our friend 'workshop'.  A namespace is just a different way to organize data, and your keyspace is right there.  In fact, your keyspace should be in your environment variables, but just to check, try this:

`cat ~/.astrarc | grep KEYSPACE`{{execute}}

If that says "workshop" you're good to go, you'll get that for free as the KS placeholder in the queries.

Otherwise just edit that file (it's in your current directory) to change the KEYSPACE to 'workshop'.

## 2. Write a document

OK, let's get some cavemen in there!  The collection name will be auto-created when you add the document, so it doesn't have to exist ahead of time.  We'll use the KS shortcut to grab the keyspace from our credentials resource file.

`http POST :/rest/v2/namespaces/KS/collections/cavemen json:='{"firstname": "Fred", "lastname": "Flintstone"}'`{{execute}}

Hmm, that document ID isn't easy to use, let's go ahead and specify one explicitly for Barney.

`http PUT :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble json:='{"firstname": "Barney", "lastname": "Rubble"}'`{{execute}}

Let's make sure our documents were written correctly:

`http :/rest/v2/namespaces/KS/collections/cavemen page-size==5`{{execute}}

## 3. Read documents

IF you know the ID of your document, it's easy to see what's there:

`http :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble`{{execute}}

But where is Fred?  I didn't write down his document ID!  You can get the Document ID for anything by querying the values in the document.

`http GET :/rest/v2/namespaces/KS/collections/cavemen where=='{"firstname": { "$eq": "Fred"}}'`{{execute}}

The "where" clause is really powerful, and allows you to combine different elements to really zero in on the document you want.

You can even get just a subset of the document by specifying a particular section in the path.

`http :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble/firstname`{{execute}}

and you can use "where" to specify a range of documents:

`http GET :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble where:='{"lastname": {"$gt": "Flintstone"}}'`{{execute}}

## 3. Update documents

So now we have Fred and Barney, but once again we haven't given Fred a job.  He just annoys Wilma when he hangs out at home, so that won't do at all.

Here's how you give Fred a job and get him out of Wilma's hair.  Remember, we just got his ID a few commands ago.  Let's grab it again and set it in the environment so we can use it as we like.

I'd like to give you a one-click way to set an env variable but alas, I think you will have to type a few characters into the terminal.

First, get your documentId.

`http :/rest/v2/namespaces/KS/collections/cavemen where=='{"firstname": { "$eq": "Fred"}}'`{{execute}}

Next, export that ID into your environment

`export DOCUMENT_ID=`{{copy}

Again, giving Fred a job. Wilma thanks you.

`http PATCH :/rest/v2/namespaces/KS/collections/cavemen/$DOCUMENT_ID json:='{"firstname":"Fred","lastname":"flintstone","occupation":"Quarry Screamer"}'`{{execute}}

So, how's Fred looking now?

`http GET :/rest/v2/namespaces/KS/collections/cavemen/$DOCUMENT_ID`{{execute}}


## 5. Delete the table

Not surprisingly, with this API, to delete a document you just, well, DELETE the document.

Let's go ahead and kick Barney out again.  He's gotta be used to it by now.

`http DELETE :/rest/v2/namespaces/KS/collections/cavemen/BarneyRubble`{{execute}}

But what if you're done with all the cavemen and want to clear out your documents?  This one is also really easy:

`http DELETE :/rest/v2/namespaces/KS/collections/cavemen`{{execute}}

Fantastic!  We've gone over all three of the API types.  Next we'll harness the APIs using @astrajs, a handy node library.

<div id="navigation-bottom" class="navigation-bottom">
 <a href='command:katapod.loadPage?[{"step":"step4"}]'
   class="btn btn-dark navigation-bottom-left">⬅️ Back - GraphQL API
 </a>
  <a href='command:katapod.loadPage?[{"step":"finish"}]'
    class="btn btn-dark navigation-bottom-right">Finish
  </a>
</div>
