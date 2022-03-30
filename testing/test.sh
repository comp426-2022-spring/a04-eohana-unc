#!/bin/zsh

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
NC='\e[0m'
echo "Passed Tests:" > tmpfiles/passed; echo "Failed Tests:" > tmpfiles/failed;

# TEST: Run normal server operations
echo "Running session for ${BLUE}Normal server on random port${NC}\n"
(node ../server.js --port=41459 > tmpfiles/server_output) & sleep 1

# Writing subtests

# TEST: Run curl on app/flip
echo "Running session for ${BLUE}app/flip${NC}\n"
result=$(curl http://localhost:41459/app/flip)
expected=$(echo "{['\"]?flip['\"]?:['\"]?(heads|tails)['\"]?}\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip${NC}" && echo "${GREEN}app/flip${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip${NC}" &&  echo "${RED}app/flip${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get header on app/flip
echo "Running session for ${BLUE}app/flip header${NC}\n"
result=$(curl -I http://localhost:41459/app/flip)
expected=$(echo "200 OK\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip header${NC}" && echo "${GREEN}app/flip header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip header${NC}" &&  echo "${RED}app/flip header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found header
echo "Running session for ${BLUE}not found header${NC}\n"
result=$(curl -I http://localhost:41459/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found header${NC}" && echo "${GREEN}not found header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found header${NC}" &&  echo "${RED}not found header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found
echo "Running session for ${BLUE}not found${NC}\n"
result=$(curl http://localhost:41459/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found${NC}" && echo "${GREEN}not found${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found${NC}" &&  echo "${RED}not found${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Random flips
echo "Running session for ${BLUE}app/flips/121 (generated randomly)${NC}\n"
result=$(curl http://localhost:41459/app/flips/121)
expected=$(echo "{['\"]?raw['\"]?:\s*\[((['\"]?tails['\"]?|['\"]?heads['\"]?),?){121}\],\s*['\"]?summary['\"]?:{(['\"]?tails['\"]?:\d{1,6},?|['\"]heads['\"]:\d{1,6},?){1,2}}}\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flips/121 (generated randomly)${NC}" && echo "${GREEN}app/flips/121 (generated randomly)${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flips/121 (generated randomly)${NC}" &&  echo "${RED}app/flips/121 (generated randomly)${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Heads
echo "Running session for ${BLUE}app/flip/call/heads${NC}\n"
result=$(curl http://localhost:41459/app/flip/call/heads)
expected=$(echo "(win|lose)\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/heads${NC}" && echo "${GREEN}app/flip/call/heads${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/heads${NC}" &&  echo "${RED}app/flip/call/heads${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Tails
echo "Running session for ${BLUE}app/flip/call/tails${NC}\n"
result=$(curl http://localhost:41459/app/flip/call/tails)
expected=$(echo "(win|lose)\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/tails${NC}" && echo "${GREEN}app/flip/call/tails${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/tails${NC}" &&  echo "${RED}app/flip/call/tails${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call invalid
echo "Running session for ${BLUE}app/flip/call/invalid${NC}\n"
result=$(curl http://localhost:41459/app/flip/call/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip/call/invalid${NC}" && echo "${GREEN}app/flip/call/invalid${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip/call/invalid${NC}" &&  echo "${RED}app/flip/call/invalid${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on non-debug session${NC}\n"
result=$(curl http://localhost:41459/app/log/access)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on non-debug session${NC}" && echo "${GREEN}/app/log/access on non-debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on non-debug session${NC}" &&  echo "${RED}/app/log/access on non-debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/error on non-debug session${NC}\n"
result=$(curl http://localhost:41459/app/error)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/error on non-debug session${NC}" && echo "${GREEN}/app/error on non-debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/error on non-debug session${NC}" &&  echo "${RED}/app/error on non-debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --port=41459" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 41459\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Normal server on random port${NC}" && echo "${GREEN}Normal server on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Normal server on random port${NC}" &&  echo "${RED}Normal server on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run help command
echo "Running session for ${BLUE}Run help command${NC}\n"
result=$(../server.js --help)
expected=$(echo "server.js [options][\s\S]*--port[\s\S]*--debug[\s\S]*--log[\s\S]*--help[\s\S]*\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Run help command${NC}" && echo "${GREEN}Run help command${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Run help command${NC}" &&  echo "${RED}Run help command${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# TEST: Run server in debug mode
echo "Running session for ${BLUE}server in debug mode on random port${NC}\n"
(node ../server.js --debug=true --port=17897 > tmpfiles/server_output) & sleep 1

# Writing subtests

# TEST: Log access
echo "Running session for ${BLUE}/app/log/access on debug session${NC}\n"
result=$(curl http://localhost:17897/app/log/access)
expected=$(echo "NEED TO WRITE THIS TEST\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/log/access on debug session${NC}" && echo "${GREEN}/app/log/access on debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/log/access on debug session${NC}" &&  echo "${RED}/app/log/access on debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Log access
echo "Running session for ${BLUE}/app/error on debug session${NC}\n"
result=$(curl http://localhost:17897/app/error)
expected=$(echo "Error test successful.\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed /app/error on debug session${NC}" && echo "${GREEN}/app/error on debug session${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed /app/error on debug session${NC}" &&  echo "${RED}/app/error on debug session${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --debug=true --port=17897" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 17897\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed server in debug mode on random port${NC}" && echo "${GREEN}server in debug mode on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed server in debug mode on random port${NC}" &&  echo "${RED}server in debug mode on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


echo "\n\n"
cat tmpfiles/passed
echo "\n"
cat tmpfiles/failed
echo "\n"
