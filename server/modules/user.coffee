mongoose = require 'mongoose'
db = require '../components/mongodb'

userSchema = mongoose.Schema
  name: type: String

user = db.model 'webhook-user', userSchema

module.exports = user
