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


module.exports=db;