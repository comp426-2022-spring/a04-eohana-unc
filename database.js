"use strict";

const Database = require("better-sqlite3");
const getpath = require("./getpath.js");

const db = new Database(`${getpath(process.argv[1])}/databases/log.db`);

const tableName = db.prepare(`SELECT 
  name
FROM 
  sqlite_master
WHERE 
  type ='table' AND 
  name = 'log';`).get();

if (!tableName){
  const dbInit = `CREATE TABLE log (
    id INTEGER PRIMARY KEY,
    remoteaddr TEXT,
    remoteuser TEXT,
    time INTEGER,
    method TEXT,
    url TEXT,
    protocol TEXT,
    httpversion TEXT,
    secure TEXT,
    status INTEGER,
    referer TEXT,
    useragent TEXT
    );`;
  db.exec(dbInit);
}

// const dbInsert = (`INSERT INTO log 
// (remoteaddr, remoteuser, time, 
//   method, url, protocol, 
//   httpversion, secure, status, 
//   referer, useragent) 
// VALUES
//   (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
// `);
// const stmt = db.prepare(dbInsert)
// stmt.run("a", "b", 234, "h", "u", "p", "v", "ns", "s", "r", "u")

// const row = db.prepare("SELECT * FROM log");
// // console.log(row.run());
// console.log(row.all())


// 2022-12-12
// if (!table) {
//   console.log("No table")
// }
// console.dir(db)
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

module.exports=db;