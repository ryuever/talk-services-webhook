mongoose = require 'mongoose'
config = require 'config'
logger = require 'graceful-logger'
mongoose.promise = require 'bluebird'

opt =
  auth:
    authdb: config.mongoAuthDB

db = mongoose.createConnection(config.mongodb, opt)

db.once 'open', ->
  logger.info 'MongoDB has been connected on port 27017'

module.exports = db
