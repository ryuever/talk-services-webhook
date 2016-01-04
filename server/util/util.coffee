config = require 'config'
crypto = require 'crypto'
uuid = require 'uuid'

module.exports =

  _CreateHashId : ->
    crypto.createHash('sha1').update(uuid.v4() + Date.now()).digest('hex')

  _BuildCallbackUrl : (hashId, service) ->
    "#{config.accountUrl}/webhook/#{service}/#{hashId}"
