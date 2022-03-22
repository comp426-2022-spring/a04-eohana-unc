#!/bin/zsh

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
NC='\e[0m'
echo "Passed Tests:" > tmpfiles/passed; echo "Failed Tests:" > tmpfiles/failed;

# TEST: Run normal server operations
echo "Running session for ${BLUE}Normal server on random port${NC}\n"
(node ../server.js --port=27312 > tmpfiles/server_output) & sleep 1

# Writing subtests

# TEST: Run curl on app/flip
echo "Running session for ${BLUE}app/flip${NC}\n"
result=$(curl http://localhost:27312/app/flip)
expected=$(echo "{['\"]?flip['\"]?:['\"]?(heads|tails)['\"]?}\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip${NC}" && echo "${GREEN}app/flip${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip${NC}" &&  echo "${RED}app/flip${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get header on app/flip
echo "Running session for ${BLUE}app/flip header${NC}\n"
result=$(curl -I http://localhost:27312/app/flip)
expected=$(echo "200 OK\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip header${NC}" && echo "${GREEN}app/flip header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip header${NC}" &&  echo "${RED}app/flip header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found header
echo "Running session for ${BLUE}not found header${NC}\n"
result=$(curl -I http://localhost:27312/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found header${NC}" && echo "${GREEN}not found header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found header${NC}" &&  echo "${RED}not found header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Get not found
echo "Running session for ${BLUE}not found${NC}\n"
result=$(curl http://localhost:27312/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found${NC}" && echo "${GREEN}not found${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found${NC}" &&  echo "${RED}not found${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Random flips
echo "Running session for ${BLUE}Random flips${NC}\n"
result=$(curl http://localhost:27312/app/flips/129)
expected=$(echo "{['\"]?raw['\"]?:\s*\[((['\"]?tails['\"]?|['\"]?heads['\"]?),?){129}\],\s*['\"]?summary['\"]?:{(['\"]?tails['\"]?:\d{1,6},?|['\"]heads['\"]:\d{1,6},?){1,2}}}\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Random flips${NC}" && echo "${GREEN}Random flips${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Random flips${NC}" &&  echo "${RED}Random flips${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Heads
echo "Running session for ${BLUE}Call heads${NC}\n"
result=$(curl http://localhost:27312/app/flip/call/heads)
expected=$(echo "(win|lose)\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Call heads${NC}" && echo "${GREEN}Call heads${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Call heads${NC}" &&  echo "${RED}Call heads${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call Tails
echo "Running session for ${BLUE}Call tails${NC}\n"
result=$(curl http://localhost:27312/app/flip/call/tails)
expected=$(echo "(win|lose)\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Call tails${NC}" && echo "${GREEN}Call tails${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Call tails${NC}" &&  echo "${RED}Call tails${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 

# TEST: Call invalid
echo "Running session for ${BLUE}Call invalid${NC}\n"
result=$(curl http://localhost:27312/app/flip/call/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Call invalid${NC}" && echo "${GREEN}Call invalid${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Call invalid${NC}" &&  echo "${RED}Call invalid${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Finished subtests
ps | grep "node ../server.js --port=27312" | grep -v grep | awk '{print $1}' | read pid
; kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 27312\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Normal server on random port${NC}" && echo "${GREEN}Normal server on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Normal server on random port${NC}" &&  echo "${RED}Normal server on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


echo "\n\n"
cat tmpfiles/passed
echo "\n"
cat tmpfiles/failed
echo "\n"
