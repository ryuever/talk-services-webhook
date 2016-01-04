app = require '../server'

req = app.request

req.allowedKeys = [ 'hashId','name', 'refer', 'username', 'sid', 'user', 'uid']
