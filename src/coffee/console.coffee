KEYS =
  ENTER: 13
  
window.onload = =>
  inputArea = document.getElementById 'inputArea'
  inputArea.onkeydown = keyDown
  inputArea.onkeyup = keyUp
  inputArea.focus()
  inputArea.setSelectionRange 2,2
  
expressionLines = []
newLine = false
keyDown = (event) ->
  newLine = false
  inputArea = document.getElementById 'inputArea'
  if event.keyCode is KEYS.ENTER
    lines = inputArea.value.split '\n'
    lastLine = lines[lines.length-1]
    lastLine = lastLine.replace '\$ ', ''
    if lastLine is 'clear'
      inputArea.value = ''
      return
    
    expressionLines.push lastLine+' '
    completeExpression = expressionLines.reduce (a,b) -> a + b
    if isCommasBalanced completeExpression
      tokens = tokenize completeExpression
      parsed = parseTokens tokens
      console.log parsed
      result = evalExpression parsed
      console.log result
      if result? then inputArea.value += '\n'+result.toString()
      expressionLines = []
      newLine = true
        
keyUp = (event) ->
  inputArea = document.getElementById 'inputArea'
  if event.keyCode is KEYS.ENTER and newLine
    inputArea.value += "$ "

isCommasBalanced = (string) ->
  openingCommas = string.split('(').length - 1
  closingCommas = string.split(')').length - 1
  openingCommas is closingCommas
