"use strict";

const fs = require("fs");
const f = fs.readFileSync("./tests.json");
const tests = JSON.parse(f);


function write_tests(tests) {
  let result = ``;
  // loop through tests

  for (let test of tests){
    result += write_server_session(test)
    result += `\n\n`
  }
  return result;
}

function write_server_session(test){

  let string_replacement = {
    "%PORT%": 1024 + Math.floor(Math.random() * (49151 - 1024) )
  };
  const server_command=`${test["run-command"]}${join_args(test["args"])}`
  // Add description in file for easy locating
  let result = `# TEST: ${test["description"]}\n`;
  // Display the test being run
  result += `echo "Running session for \${BLUE}${test["test-name"]}\${NC}\\n"\n`;
  // run the command with the args (will replace port at the end)
  result += `(${server_command}) > tmpfiles/server_output & sleep 1\n\n`; 
  for (let ct of test["client-tests"]){
    result += `${write_client_test(ct)}\n\n`;
  }

  if (test["server-persistent"]){
    result += `ps | grep "${server_command}" | grep -v grep | awk '{print $1}' | read pid\n`;
    result += `kill $pid\n`;
  }
  result += `result=$(cat tmpfiles/server_output)\n`;
  result += write_evaluation(test)
  result += `\n\n`;
  for (let item in string_replacement){
    result = result.replaceAll(item, string_replacement[item]);
  }
  return result;
}

function write_client_test(test){
  let result = ``;
  let string_replacement = {
    "%Q%": "\\\""
  };
  result += `# Client test for ${test["description"]}\n`;
  result += `echo "Running client test for ${test["test-name"]}"\n`;
  result += `result=$(curl${join_args(test["args"])} ${test["address"]})\n`;
  result += write_evaluation(test)
  result += `\n`;
  for (let item in string_replacement){
    result = result.replaceAll(item, string_replacement[item]);
  }
  return result;
}

function write_evaluation(test){
  let result = "";
  result += `expected=$(echo "${test["expected"]}\\n")\n`;
  result += `match="$(echo $result | grep -E $expected)"\n`;
  // result += `echo "Expected: $expected"\n`;
  // result += `echo "Result: $result"\n`;
  // result += `echo "Match: $match"\n`;
  result += `[ -n "$match" ] && ( echo "\${GREEN}Passed ${test["test-name"]}\${NC}" && echo "\${GREEN}${test["test-name"]}\${NC}" >> tmpfiles/passed ) || ( echo "\${RED}Failed ${test["test-name"]}\${NC}" &&  echo "\${RED}${test["test-name"]}\${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) `;
  // result += `[ -n "$match" ] && ( echo "\${GREEN}Passed ${test["test-name"]}\${NC}" ) || ( echo "\${RED}Failed ${test["test-name"]}\${NC}" )`;
  // result += `[ -n "$match" ] && ( echo "\${GREEN}Passed ${test["test-name"]}\${NC}" && passed=\`expr $passed + 1\` ) || ( echo "\${RED}Failed ${test["test-name"]}\${NC}" && failed=\`expr $failed + 1\`)`;
  return result
}
function join_args(args){
  let result = "";
  for (let arg of args){
    result += ` ${arg}`;
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

content += `echo "" > tmpfiles/passed; echo "" > tmpfiles/failed;\n\n`
// content += `declare -i passed; declare -i failed; declare -i total\n\n`
content += write_tests(tests)

// content += `echo "Total tests: $total, Passed \${GREEN}$passed\${NC}, Failed \${RED}$failed\${NC}\\n"\n`
// content += `echo "hello world"`;
content += `echo "Passed tests:" && cat tmpfiles/passed\n`
content += `echo "\\n"\n`
content += `echo "Failed tests:" && cat tmpfiles/failed\n`

fs.writeFile("test.sh", content, err => {
  if (err){
    console.error(err);
  }
});
