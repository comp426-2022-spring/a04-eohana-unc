function getpath(string){
  let result = ""
  let index = 0
  for (let i = string.length - 1; i >= 0; i--){
    if (string[i] === "/"){
      index = i;
      break;
    }
  }
  for (let i = 0; i < index; i++){
    result += string[i]
  }
  return result
}

module.exports = getpath