const express = require('express')
const morgan = require("morgan")

const fs = require("fs")
const args = require("minimist")(process.argv)
const getpath = require("./getpath.js")
const db = require("./database.js")
const coin = require("./modules/coin.js")

const data_path = ""
const app = express()
const port = args["port"] || 5000

if (args["help"]){
  const text = fs.readFileSync(`${getpath(process.argv[1])}/files/help.txt`, {encoding: "ascii", flag:"r"})
  console.log(text)
  process.exit(0)
}


app.use((req, res, next) => {
  next()

  let logdata = {
    remoteaddr: req.ip || "",
    remoteuser: req.user || "",
    time: Date.now(),
    method: req.method || "",
    url: req.url || "",
    protocol: req.protocol || "",
    httpversion: req.httpVersion || "",
    secure: req.secure || "",
    status: res.statusCode || "",
    referer: req.headers['referer'] || "",
    useragent: req.headers['user-agent'] || ""
  }

const dbInsert = (`INSERT INTO log 
    (remoteaddr, remoteuser, time, 
      method, url, protocol, 
      httpversion, secure, status, 
      referer, useragent) 
  VALUES
    (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `)
  const stmt = db.prepare(dbInsert)
  stmt.run(logdata.remoteaddr, logdata.remoteuser, logdata.time, logdata.method,
    logdata.url, logdata.protocol, logdata.httpversion, logdata.secure, logdata.status,
    logdata.referer, logdata.useragent)
})


if (args["debug"]=='true' || args["debug"]){
  // console.log("debug mode")
  app.get('/app/log/access', (req, res) => {
    const stmt = db.prepare("SELECT * FROM log").all()
    res.status(200).json(stmt)
  })

  app.get('/app/error', (req, res) => {
    res.status(200).end("Error test successful.")
  })
}

if (args["log"]!='false'){
  const writeStream = fs.createWriteStream(`${getpath(process.argv[1])}/${data_path}access.log`, {flags: 'a'})
  app.use(morgan ("combined", {stream: writeStream}))
}


app.get('/app', (req, res) => {
  res.statusCode = 200
  res.statusMessage = "OK"
  res.writeHead(res.statusCode, {"Content-Type": "text/plain"})
  res.end(res.statusCode + " " + res.statusMessage)
})

app.get('/app/flip', (req, res) => {
  res.statusCode = 200
  res.statusMessage = "OK"
  // res.writeHead(res.statusCode, {"Content-Type": "application/json"})
  let flip = coin.coinFlip()
  // console.log(flip)
  res.json({"flip": flip})
  res.end()
})

app.get('/app/flips/:number', (req, res) => {
  res.statusCode = 200
  res.statusMessage = "OK"
  // res.writeHead(res.statusCode, {"Content-Type": "application/json"})
  numFlips = parseInt(req.params.number) || 1
  let flips = coin.coinFlips(numFlips)
  // console.log(flip)
  res.json({
    // "aaa":"bbb"
    "raw": flips,
    "summary": coin.countFlips(flips)
})
  res.end()
})

app.get('/app/flip/call/:call(heads|tails)', (req, res) => {
  res.statusCode = 200
  res.statusMessage = "OK"
  res.json(coin.flipACoin(req.params.call)).end()
})


app.use((req, res) => {
  res.status(404).send('404 NOT FOUND')
})


app.listen(port, () => {
  console.log('App listening on port %PORT%'.replace('%PORT%',port))
})