app = require '../server'
userModel = require '../modules/user'
integrationModel = require '../modules/integration'

util = require '../util/util'
config = require 'config'

module.exports = userController = app.controller "user", ->

  @action 'index', (req, res, callback) ->

    if req.cookies.user or req.session?.uid
      @signin req, res, callback
    else
      res.render 'login'

  @action 'signin', (req, res, callback) ->
    username = req.get('username')
    uid = req.cookies?.user or req.get('user')?._id

    if username
      condition = name: username
    else
      condition = _id: uid

    userModel.findOne condition
    .exec()
    .then (user, err) ->

      cookieOptions =
        domain: config.cookieDomain
        expires: new Date (Date.now() + 86400 * 1000)

      res.clearCookie 'user', cookieOptions

      return res.redirect '/' unless user

      res.cookie 'user',user._id, cookieOptions
      req.session.uid = user._id

      integrationModel.find creator: user._id
      .exec()
      .then (integrations, err) ->
        res.render 'index', title: 'Testing webhook incoming', integrations: integrations, user: user

  @action 'signup', (req, res, callback) ->
    {username} = req.get()

    userModel.findOne name: username
    .exec()
    .then (ret, err) ->

      return res.status(400).json err: 'user already exist' if err

      user = new userModel name: username

      user.save (err, user) ->

        cookieOptions =
          domain: config.cookieDomain
          expires: new Date (Date.now() + 86400 * 1000)

        res.clearCookie 'user', cookieOptions
        res.cookie 'user',user.name, cookieOptions
        req.session.uid = user._id
        res.render 'index', 'user': user

  @action 'logout', (req, res, callback) ->

    cookieOptions =
      domain: config.cookieDomain
      expires: new Date (Date.now() + 86400 * 1000)

    res.clearCookie 'user', cookieOptions

    req.session.destroy ()->
      res.redirect '/'
