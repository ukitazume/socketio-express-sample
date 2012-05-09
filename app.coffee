express = require("express")
socketIO = require('socket.io')
routes = require("./routes")

app = module.exports = express.createServer()
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "ejs"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )


app.configure "production", ->
  app.use express.errorHandler()

app.get "/", routes.index


sockets = socketIO.listen(app)
sockets.on 'connection', (socket) ->
  socket.broadcast.emit 'news', { content: 'other joined'}
  socket.emit 'news', { content: 'hello!! '}
  socket.on 'message', (msg) ->
    socket.emit 'message', {content: msg, who: 'you'}
    socket.broadcast.emit 'message', {content: msg, who: 'others'}

app.listen 3030, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
