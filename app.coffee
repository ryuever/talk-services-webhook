logger = require 'graceful-logger'
server = require('./server/server')
port = process.env.PORT or 7510

server.listen port, -> logger.info "Server listen on #{port}"
