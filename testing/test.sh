#!/bin/zsh

RED='\e[1;31m'
BLUE='\e[1;34m'
GREEN='\e[1;32m'
NC='\e[0m'
# TEST: Run normal server operations
echo "Running session for ${BLUE}Normal server on random port${NC}\n"
(node ../server.js --port=38231 ) > tmpfiles/server_output & sleep 1


ps | grep "node ../server.js --port=38231" | grep -v grep | awk '{print $1}' | read pid
kill $pid
expected=$(echo "App listening on port 38231")
result=$(cat tmpfiles/server_output)
match="$(echo $result | grep -E $expected)"
echo "Expected: $expected"
echo "Result: $result"
echo "Match: $match"
[ -n "$match" ] && echo "${GREEN}Passed Normal server on random port${NC}" || echo "${RED}Failed Normal server on random port${NC}"



