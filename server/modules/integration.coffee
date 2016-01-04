mongoose = require 'mongoose'
db = require '../components/mongodb'

integrationSchema = mongoose.Schema
  creator: type: mongoose.Schema.Types.ObjectId, ref: 'user'
  hashId: type: String
  name: type: String
  refer: type: String
  content: [
    headers: type: String
    body: type: String
    msgTime: type: Date, default: Date.now
  ]

integrationSchema.virtual '_creatorId'
  .get -> @creator?._id or @creator
  .set (_id) -> @creator = _id

integration = db.model 'webhook-integration', integrationSchema

module.exports = integration
