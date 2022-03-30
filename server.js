const express = require('express')
const fs = require("fs")
const app = express()
const args = require("minimist")(process.argv)

if (args["help"]){
  const currentdir = process.argv[1].replace("server.js", "")
  const text = fs.readFileSync(`${currentdir}files/help.txt`, {encoding: "ascii", flag:"r"})
  console.log(text)
  process.exit(0)
}

const coin = require("./modules/coin.js")

const port = args["port"] || 5000

// console.log(coin.coinFlip())

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