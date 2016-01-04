talk-services-webhook
===

It is used to test the incoming webhook message.

# startup

```bash
$ coffee app.coffee
```

# webhook url format

* A new webhook url will be created when you click the `service` button on index page's left side. The format is under `/webhook/incoming/xxxxx`, xxx is for hashId.
* In order to get push notification, you should copy the created webhook url to the target service's webhook setting page. Then it will trigger the `/webhook/:refer/:hashId` route on the server.