#!/bin/zsh

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
NC='\e[0m'
echo "Passed Tests:" > tmpfiles/passed; echo "Failed Tests:" > tmpfiles/failed;

# TEST: Run normal server operations
echo "Running session for ${BLUE}Normal server on random port${NC}\n"
(node ../server.js --port=3047 > tmpfiles/server_output) & sleep 1

# Writing subtests

# TEST: Run curl on app/flip
echo "Running session for ${BLUE}app/flip${NC}\n"
result=$(curl http://localhost:3047/app/flip)
expected=$(echo "{['\"]?flip['\"]?:['\"]?(heads|tails)['\"]?}")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip${NC}" && echo "${GREEN}app/flip${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip${NC}" &&  echo "${RED}app/flip${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get header on app/flip
echo "Running session for ${BLUE}app/flip header${NC}\n"
result=$(curl -I http://localhost:3047/app/flip)
expected=$(echo "200 OK")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip header${NC}" && echo "${GREEN}app/flip header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip header${NC}" &&  echo "${RED}app/flip header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found header
echo "Running session for ${BLUE}not found header${NC}\n"
result=$(curl -I http://localhost:3047/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found header${NC}" && echo "${GREEN}not found header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found header${NC}" &&  echo "${RED}not found header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found
echo "Running session for ${BLUE}not found${NC}\n"
result=$(curl http://localhost:3047/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found${NC}" && echo "${GREEN}not found${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found${NC}" &&  echo "${RED}not found${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Random flips
echo "Running session for ${BLUE}app/flips/104 (generated randomly)${NC}\n"
result=$(curl http://localhost:3047/app/flips/104)
expected=$(echo "{['\"]?raw['\"]?:\s*\[((['\"]?tails['\"]?|['\"]?heads['\"]?),?){104}\],\s*['\"]?summary['\"]?:{(['\"]?tails['\"]?:\d{1,6},?|['\"]heads['\"]:\d{1,6},?){1,2}}}")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flips/104 (generated randomly)${NC}" && echo "${GREEN}app/flips/104 (generated randomly)${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flips/104 (generated randomly)${NC}" &&  echo "${RED}app/flips/104 (generated randomly)${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Heads
echo "Running session for ${BLUE}app/flip/call/heads${NC}\n"
result=$(curl http://localhost:3047/app/flip/call/heads)
expected=$(echo "(win|lose)")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/heads${NC}" && echo "${GREEN}app/flip/call/heads${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/heads${NC}" &&  echo "${RED}app/flip/call/heads${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Tails
echo "Running session for ${BLUE}app/flip/call/tails${NC}\n"
result=$(curl http://localhost:3047/app/flip/call/tails)
expected=$(echo "(win|lose)")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/tails${NC}" && echo "${GREEN}app/flip/call/tails${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/tails${NC}" &&  echo "${RED}app/flip/call/tails${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call invalid
echo "Running session for ${BLUE}app/flip/call/invalid${NC}\n"
result=$(curl http://localhost:3047/app/flip/call/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/invalid${NC}" && echo "${GREEN}app/flip/call/invalid${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/invalid${NC}" &&  echo "${RED}app/flip/call/invalid${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on non-debug session${NC}\n"
result=$(curl http://localhost:3047/app/log/access)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on non-debug session${NC}" && echo "${GREEN}/app/log/access on non-debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on non-debug session${NC}" &&  echo "${RED}/app/log/access on non-debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/error on non-debug session${NC}\n"
result=$(curl http://localhost:3047/app/error)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/error on non-debug session${NC}" && echo "${GREEN}/app/error on non-debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/error on non-debug session${NC}" &&  echo "${RED}/app/error on non-debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --port=3047" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 3047")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Normal server on random port${NC}" && echo "${GREEN}Normal server on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Normal server on random port${NC}" &&  echo "${RED}Normal server on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run help command
echo "Running session for ${BLUE}Run help command${NC}\n"
result=$(node ../server.js --help)
expected=$(echo "server\.js \[options\][\s\S]*")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Run help command${NC}" && echo "${GREEN}Run help command${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Run help command${NC}" &&  echo "${RED}Run help command${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run server in debug mode
echo "Running session for ${BLUE}server in debug mode on random port${NC}\n"
(node ../server.js --debug=true --port=12905 > tmpfiles/server_output) & sleep 1

# Writing subtests

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on debug session${NC}\n"
result=$(curl http://localhost:12905/app/log/access)
expected=$(echo "\[\{['\"]id['\"]:.{0,40},['\"]remoteaddr['\"]:.*,['\"]remoteuser['\"]:.*,.*['\"]useragent['\"]:.*\}\]")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on debug session${NC}" && echo "${GREEN}/app/log/access on debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on debug session${NC}" &&  echo "${RED}/app/log/access on debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/error on debug session${NC}\n"
result=$(curl http://localhost:12905/app/error)
expected=$(echo "Error test successful.")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/error on debug session${NC}" && echo "${GREEN}/app/error on debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/error on debug session${NC}" &&  echo "${RED}/app/error on debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access header
echo "Running session for ${BLUE}/app/error header on debug session${NC}\n"
result=$(curl -I http://localhost:12905/app/error)
expected=$(echo ".*500 Internal Server Error.*")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/error header on debug session${NC}" && echo "${GREEN}/app/error header on debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/error header on debug session${NC}" &&  echo "${RED}/app/error header on debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --debug=true --port=12905" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 12905")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed server in debug mode on random port${NC}" && echo "${GREEN}server in debug mode on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed server in debug mode on random port${NC}" &&  echo "${RED}server in debug mode on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run server in log mode (default)
echo "Running session for ${BLUE}server in log mode on random port${NC}\n"
(( cp ../access.log ./ ) & ( node ../server.js --log=true --port=11417 > tmpfiles/server_output )) & sleep 1

# Writing subtests

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on non debug session${NC}\n"
result=$(curl http://localhost:11417/app/log/access)
expected=$(echo "404 NOT FOUND")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on non debug session${NC}" && echo "${GREEN}/app/log/access on non debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on non debug session${NC}" &&  echo "${RED}/app/log/access on non debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --log=true --port=11417" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(diff ../access.log ./access.log)
expected=$(echo ".+")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed server in log mode on random port${NC}" && echo "${GREEN}server in log mode on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed server in log mode on random port${NC}" &&  echo "${RED}server in log mode on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run server not in log mode (default)
echo "Running session for ${BLUE}server not in log mode on random port${NC}\n"
(( cp ../access.log ./ ) & ( node ../server.js --log=false --port=13422 > tmpfiles/server_output )) & sleep 1

# Writing subtests

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on non debug session${NC}\n"
result=$(curl http://localhost:13422/app/log/access)
expected=$(echo "404 NOT FOUND")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on non debug session${NC}" && echo "${GREEN}/app/log/access on non debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on non debug session${NC}" &&  echo "${RED}/app/log/access on non debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --log=false --port=13422" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(echo -n 098231 && diff ../access.log ./access.log && echo -n 234524)
expected=$(echo "098231234524")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed server not in log mode on random port${NC}" && echo "${GREEN}server not in log mode on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed server not in log mode on random port${NC}" &&  echo "${RED}server not in log mode on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


echo "\n\n"
cat tmpfiles/passed
echo "\n"
cat tmpfiles/failed
echo "\n"
