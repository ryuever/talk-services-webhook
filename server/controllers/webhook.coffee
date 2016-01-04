app = require '../server'
util = require '../util/util'
config = require 'config'
userModel = require '../modules/user'
_ = require 'lodash'
integrationModel = require '../modules/integration'

module.exports = webhookController = app.controller 'webhook', ->

  @action 'add', (req, res, callback) ->
    {user, name, refer} = req.get()

    hashId = util._CreateHashId()
    integration = _creatorId: user._id, refer: refer, name: name, hashId: hashId

    integration = new integrationModel integration

    integration.save()
    .then (doc, err) ->
      res.status(400).json 'err', 'Integration save error' if err
      res.status(200).json refer: refer, hashId: doc.hashId, name: name

  @action 'message', (req, res, callback) ->
    {user, refer, hashId} = req.get()

    $integration = integrationModel.findOne hashId: hashId
    .exec().then (integration, err) ->
      res.status(400).json 'err','Invalid user' if err
      res.status(200).json refer: refer, hashId: hashId, content: integration.content

  @action 'info', (req, res, callback) ->
    {user, refer, hashId} = req.get()

    integrationModel.find creator: user._id
    .exec().then (integrations, err) ->
      res.render 'index',
        title: 'Testing webhook incoming',
        integrations: integrations,
        hashId:hashId,
        user: user

  @action 'delete', (req, res, callback) ->
    {user, hashId} = req.get()

    integrationModel.findOneAndRemove hashId: hashId, (err, integration, result) ->

      return res.status(400).json 'err','Invalid user' if err
      res.status(200).json hashId: hashId, name: integration.name

  @action 'addcontent', (req, res, callback) ->
    {refer, hashId} = req.get()
    $integration = integrationModel.findOne hashId: hashId
    .exec()
    .then (integration, err) ->
      return res.status(400).json 'err','Invalid user' if err

      post_data =
        headers: JSON.stringify req.headers
        body: JSON.stringify req.body

      originContent = integration.content or []
      content = originContent.push(post_data)

      integration.content = content

      integrationModel.findOneAndUpdate _id: integration._id, integration, (err, doc)->
        res.end()

  @action 'getIntegrationByUser', (req, res, callback) ->
    {user} = req.get()

    integrationModel.find creator: user._id
    .exec()
    .then (integrations, err) ->
      res.send(integrations)

  @action 'getIntegrationAll', (req, res, callback) ->
    {user} = req.get()

    integrationModel.find {}
    .exec()
    .then (integrations, err) ->
      res.send(integrations)
