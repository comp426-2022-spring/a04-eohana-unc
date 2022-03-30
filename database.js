const Database = require("better-sqlite3")
const getpath = require("./getpath.js")

const db = new Database(`${getpath(process.argv[1])}/databases/log.db`)
// what does this do?

// so it needs to create a database if there isn't one already
// it needs to add the data types
// it needs to provide the database to the export

// NEED in database:
// let logdata = {
//   remoteaddr: req.ip,
//   remoteuser: req.user,
//   time: Date.now(),
//   method: req.method,
//   url: req.url,
//   protocol: req.protocol,
//   httpversion: req.httpVersion,
//   secure: req.secure,
//   status: res.statusCode,
//   referer: req.headers['referer'],
//   useragent: req.headers['user-agent']
// }

module.exports=db