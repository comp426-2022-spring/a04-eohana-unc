"use strict";

const fs = require("fs");
const f = fs.readFileSync("./tests.json");
const tests = JSON.parse(f);

const quotes = {
  "%q%": "\"",
  "%Q%": "\\\""
}

function write_tests(tests) {
  let result = ``;
  // loop through tests and write individual ones
  for (let test of tests){
    result += write_test(test)
    result += `\n\n`
  }
  return result;
}

function write_test(test){
  // write test description
  let result = `# TEST: ${test["description"]}\n`;
  // echo test name to user
  result += `echo "Running session for \${BLUE}${test["test-name"]}\${NC}\\n"\n`;

  // run starting command if it exists
  if (test["run-command"]){
    const runCommand = test["fork-command"] ? `(${test["run-command"]}) ${test["fork-command"]}` : `${test["run-command"]}`;
    result += `${runCommand}\n`;
  }

  // if this is a session with multiple tests, write the sub-tests
  if (test["sub-tests"]){
    result += `# Writing subtests\n`;
    result += `\n`;
    for (let subtest of test["sub-tests"]){
      result += `${write_test(subtest)}\n`;
    }
    result += '\n';
    result += `# Finished subtests\n`;

  }

  // kill session if needed
  if (test["kill-command"]){
    result += `${test["kill-command"]}\n`;
  }

  // evaluate results
  result += write_evaluation(test);

  // replace %ARGS%
  const args = join_args(test["args"]);
  result = result.replaceAll("%ARGS%", args);

  // replace other miscellaneous %stuff%
  for (let item in test["dict"]){
    result = result.replaceAll(item, write_misc(test["dict"][item]));
  }

  // replace port number
  // if (test["port"] === "random"){
  //   const port = 1024 + Math.floor(Math.random() * (49151 - 1024));
  //   result = result.replaceAll("%PORT%", port);
  // }
  for (let quote in quotes) {
    result = result.replaceAll(quote, quotes[quote]);
  }
  return `${result}\n`;
}


function write_evaluation(test){
  let result = `result=\$(${test["test-command"]})\n`;
  result += `expected=$(echo "${test["expected"]}")\n`;
  result += `match="$(echo $result | grep -E $expected)"\n`;
  result += `[ -n "$match" ] && ( echo "\${GREEN}Passed ${test["test-name"]}\${NC}" && echo "\${GREEN}${test["test-name"]}\${NC}" >> tmpfiles/passed ) || ( echo "\${RED}Failed ${test["test-name"]}\${NC}" &&  echo "\${RED}${test["test-name"]}\${NC}" >> tmpfiles/failed &&
  echo "Expected: $expected" >> tmpfiles/failed && echo "Result: $result" >> tmpfiles/failed ) `;
  return result
}
function join_args(args){

  return args.join(" ");
}

function write_misc(replacementString){
  const items = replacementString.split("-*-");
  if (items[1] === "random"){
    const lower = parseInt(items[2]);
    const upper = parseInt(items[3]);
    const randomNumber = parseInt(lower + Math.floor(Math.random() * (upper - lower)));
    replacementString = randomNumber.toString();
  }
  return replacementString
}
// write to test.sh

// declare zsh
let content = `#!/bin/zsh\n\n`;

// declare color variables
content += `RED='\\e[1;31m'\n`;
content += `BLUE='\\e[1;34m'\n`;
content += `GREEN='\\e[1;32m'\n`;
content += `NC='\\e[0m'\n`;

// write new passed and failed test files
content += `echo "Passed Tests:" > tmpfiles/passed; echo "Failed Tests:" > tmpfiles/failed;\n\n`

// write the tests
content += write_tests(tests)

// create some space after tests
content += `echo "\\n\\n"\n`;

// display the successful tests
content += `cat tmpfiles/passed\n`;
content += `echo "\\n"\n`;

// display the failed tests:
content += `cat tmpfiles/failed\n`;
content += `echo "\\n"\n`;

// write to file test.sh
fs.writeFile("test.sh", content, err => {
  if (err){
    console.error(err);
  }
});
