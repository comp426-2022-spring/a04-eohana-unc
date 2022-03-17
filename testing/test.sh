#!/bin/zsh

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
NC='\e[0m'
echo "" > tmpfiles/passed; echo "" > tmpfiles/failed;

# TEST: Run normal server operations
echo "Running session for ${BLUE}Normal server on random port${NC}\n"
(node ../server.js --port=9379) > tmpfiles/server_output & sleep 1

# Client test for Run curl on app/flip
echo "Running client test for app/flip"
result=$(curl http://localhost:9379/app/flip)
expected=$(echo "{['\"]?flip['\"]?:['\"]?(heads|tails)['\"]?}\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip${NC}" && echo "${GREEN}app/flip${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip${NC}" &&  echo "${RED}app/flip${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Client test for Get header on app/flip
echo "Running client test for app/flip header"
result=$(curl -I http://localhost:9379/app/flip)
expected=$(echo "200 OK\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed app/flip header${NC}" && echo "${GREEN}app/flip header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed app/flip header${NC}" &&  echo "${RED}app/flip header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Client test for Get not found header
echo "Running client test for not found header"
result=$(curl -I http://localhost:9379/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found header${NC}" && echo "${GREEN}not found header${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found header${NC}" &&  echo "${RED}not found header${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


# Client test for Get not found
echo "Running client test for not found"
result=$(curl http://localhost:9379/app/invalid)
expected=$(echo "404 [Nn][Oo].*[Nn][Dd]\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed not found${NC}" && echo "${GREEN}not found${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed not found${NC}" &&  echo "${RED}not found${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 


ps | grep "node ../server.js --port=9379" | grep -v grep | awk '{print $1}' | read pid
kill $pid
result=$(cat tmpfiles/server_output)
expected=$(echo "App listening on port 9379\n")
match="$(echo $result | grep -E $expected)"
[ -n "$match" ] && ( echo "${GREEN}Passed Normal server on random port${NC}" && echo "${GREEN}Normal server on random port${NC}" >> tmpfiles/passed ) || ( echo "${RED}Failed Normal server on random port${NC}" &&  echo "${RED}Normal server on random port${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) 



echo "Passed tests:" && cat tmpfiles/passed
echo "\n"
echo "Failed tests:" && cat tmpfiles/failed
