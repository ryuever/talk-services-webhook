userModel = require '../modules/user'

_user = (req, res, callback = ->) ->
  {uid} = req.get()

  userModel.findOne _id: uid
  .exec()
  .then (user) ->

    unless user
      cookieOptions =
        domain: config.cookieDomain
        expires: new Date (Date.now() + 86400 * 1000)

      res.clearCookie 'user', cookieOptions

      req.session.destroy ()->
        return res.redirect '/'

    req.set 'user', user
    callback()

auth = (options = {}) ->
  _auth = (req, res, callback = ->) ->
    if req.session?.uid
      req.set 'uid', req.session?.uid
      _user req, res, callback

    else if req.cookies?.user
      req.set 'uid', req.cookies?.user
      _user req, res, callback

    else
      return res.redirect '/'

  return _auth
module.exports = auth
