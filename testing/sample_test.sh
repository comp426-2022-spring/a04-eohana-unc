#!/bin/zsh


node ../server.js --port=4820 > tmpfiles/output &
ps && sleep 4 
ps | grep "node ../server.js --port=4820" | grep -v grep | awk '{print $1}' | read pid
kill $pid
ps
cat tmpfiles/output