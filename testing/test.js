"use strict";

const fs = require("fs");
const f = fs.readFileSync("./tests.json");
const tests = JSON.parse(f);


function write_tests(tests) {
  let result = ``;
  // loop through tests

  for (let test of tests){
    // let port = 1000 + Math.floor(Math.random() * (2**16 - 1000) )
    // result += `# TEST: ${test["description"]}\n`;
    // result += `echo "Running session for \${BLUE}${test["test-name"]}\${NC}"\n`;
    // result += `${test["run-command"]} `;
    result += write_server_session(test)
    result += `\n\n`
  }
  return result;
}

function write_server_session(test){

  let string_replacement = {
    "%PORT%": 1024 + Math.floor(Math.random() * (49151 - 1024) )
  };
  const server_command = `${test["run-command"]} ${join_args(test["args"])}`
  // Add description in file for easy locating
  let result = `# TEST: ${test["description"]}\n`;
  // Display the test being run
  result += `echo "Running session for \${BLUE}${test["test-name"]}\${NC}\\n"\n`;
  // run the command with the args (will replace port at the end)
  result += `(${test["run-command"]} ${join_args(test["args"])}) > tmpfiles/server_output & sleep 1`; 
  for (let ct of test["client-tests"]){
    result += `${write_client_test(ct)}\n\n`;
  }

  if (test["server-persistent"]){
    result += `ps | grep "node ../server.js --port=%PORT%" | grep -v grep | awk '{print $1}' | read pid\n`;
    result += `kill $pid\n`;
  }
  result += `expected=$(echo "${test["expected-output"]}")\n`;
  result += `result=$(cat tmpfiles/server_output)\n`;
  result += `match="$(echo $result | grep -E $expected)"\n`;
  result += `echo "Expected: $expected"\n`;
  result += `echo "Result: $result"\n`;
  result += `echo "Match: $match"\n`;
  result += `[ -n "$match" ] && echo "\${GREEN}Passed ${test["test-name"]}\${NC}" || echo "\${RED}Failed ${test["test-name"]}\${NC}"`;
  result += `\n\n`;
  for (let item in string_replacement){
    // console.log(`${item}: ${string_replacement[item]}`);
    result = result.replaceAll(item, string_replacement[item]);
  }
  return result;
}

function write_client_test(test){
  return "\n";
}
function join_args(args){
  let result = "";
  for (let arg of args){
    result += `${arg} `;
  }
  return result;
}
// for (let test of tests){
//   console.log(test);
// }
// TODO:

// write to test.sh

let content = `#!/bin/zsh\n\n`;
content += `RED='\\e[1;31m'\n`;
content += `BLUE='\\e[1;34m'\n`;
content += `GREEN='\\e[1;32m'\n`;
content += `NC='\\e[0m'\n`;
content += write_tests(tests)
// content += `echo "hello world"`;

fs.writeFile("test.sh", content, err => {
  if (err){
    console.error(err);
  }
});
