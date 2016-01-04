express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
morgan = require 'morgan'

jade = require 'jade'
config = require 'config'
path = require 'path'

session = require 'express-session'

app = require '../server'

app.engine 'jade', jade.__express

app.set 'views', path.join(__dirname, '../../views')
app.set 'view cache', true
app.set 'view engine', 'jade'

app.use express.static(path.join(__dirname, "../../public"))

app.use cookieParser()
app.use bodyParser.json()
app.use bodyParser.urlencoded({ extended: false })

app.use morgan 'combined'

app.use session
  secret: 'keyboard cat'
  resave: true
  saveUninitialized: true
  name: 'sid'
  cookie:
    maxAge: 86400 * 1000
