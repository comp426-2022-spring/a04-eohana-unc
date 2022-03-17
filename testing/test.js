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
  let port = 1000 + Math.floor(Math.random() * (2**16 - 1000) )
  result += `# TEST: ${test["description"]}\n`;
  result += `echo "Running session for \${BLUE}${test["test-name"]}\${NC}"\n`;
  result += `(${test["run-command"]} ${join_args(test["args"])}) & \n`;
  for (let ct of test["client-tests"]){
    result += write_client_test(ct);
  }
  result += `\n\n`
}

function write_client_test(test){
  return "\n"
}
function join_args(args){
  let result = "";
  for (let arg in args){
    result += `$arg `
  }
  return result
}
// for (let test of tests){
//   console.log(test);
// }
// TODO:

// write to test.sh

let content = `#!/bin/zsh\n\n`;
content += `RED='\\e[1;31m'\n`;
content += `BLUE='\\e[1;34m'\n`;
content += `GREEN='\\e[1;34m'\n`;
content += `NC='\\e[0m'\n`;
content += write_tests(tests)
// content += `echo "hello world"`;

fs.writeFile("test.sh", content, err => {
  if (err){
    console.error(err);
  }
});
