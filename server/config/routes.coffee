app = require '../server'
auth = require '../middlewares/auth'

app.middlewares = [auth()]

app.get '/', to: 'user#index', middlewares: []

app.post '/signup', to: 'user#signup', middlewares: []
app.post '/signin', to: 'user#signin', middlewares: []

app.get '/logout', to: 'user#logout'

app.post '/webhook/add', to: 'webhook#add'

app.delete '/webhook/delete/:hashId', to: 'webhook#delete'

app.get '/webhook/info/:refer/:hashId', to: 'webhook#info'

# click to update content
app.get '/webhook/message/:refer/:hashId', to: 'webhook#message'

app.post '/webhook/:refer/:hashId', to: 'webhook#addcontent', middlewares: []

# api
app.get '/webhook/getintegrationall', to: 'webhook#getIntegrationAll', middlewares: []

app.get '/*', to: 'user#index', middlewares: []
