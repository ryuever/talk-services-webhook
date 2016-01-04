express = require 'express'
requireDir = require 'require-dir'

sundae = require 'sundae'

app = sundae express()

module.exports = app = app

require './components/mongodb'

require './modules/user'
require './modules/integration'

requireDir './controllers', recurse: true

require './config/express'
require './config/request'
require './config/routes'
