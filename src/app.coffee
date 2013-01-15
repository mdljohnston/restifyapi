restify = require 'restify'
path = require 'path'
mysql = require 'mysql'
fs = require 'fs'
nconf = require 'nconf'

nconf.env().argv()
nconf
  .file(nconf.get('NODE_ENV'), path.join("config", "config.#{nconf.get('NODE_ENV')}.json"))
  .file('default', path.join("config", 'config.default.json'))
#nconf.set('database:host', '127.0.0.1') #localhost
#nconf.set('database:port', 3306) #mysql port

respond = (req, res, next) ->
  res.send "hello " + req.params.name

mysqlTrasactionRespond = (req, res, next) ->
  dd = nconf.get()
  connection = mysql.createConnection(
    host: nconf.get 'database:host'
    database: nconf.get 'database:database'
    user: nconf.get 'database:user'
    password: nconf.get 'database:password'
  )
  connection.connect()
  connection.query "SELECT * FROM `User` as usrs", (err, rows, fields) ->
    console.log err  if err
    console.log "The solution is: ", rows

  connection.end()
  res.send "working here biatches" +req.params.id

server = restify.createServer()
server.get "/hello/:name", respond
server.head "/hello/:name", respond
server.get "/transaction/:id", mysqlTrasactionRespond

server.listen 8080, ->
  console.log "%s listening at %s", server.name, server.url