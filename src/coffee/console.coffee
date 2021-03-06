KEYS =
  BACKSPACE: 8
  TAB: 9
  ENTER: 13
  CTRL: 17
  LEFT: 37
  UP: 38
  C: 67

COMPILE_START_STRING = '*** GENERATED JAVASCRIPT ***'

$ ->
  input = $ '#input'
  repl = $ '#console'
  navbar = $ '#navbar'
  buttonGroup = $ '#button-group'
  win = $ window
  inputHeight = win.height() - (navbar.height() + buttonGroup.height()) - 50
  input.height inputHeight
  repl.height inputHeight
  repl.val '> '
  repl.keydown keyDown
  repl.keyup keyUp
  repl.mousedown mouseDown
  $('#run').click ->
    expressions = splitExpression input.val()
    for expression in expressions
      evalExpression parseTokens tokenize expression
    repl.val "#{repl.val()} ran #{expressions.length} statements\n> "
  $('#compile').click ->
    expressions = splitExpression input.val()
    compiled = ""
    for expression in expressions
      compiled += Compiler.compile parseTokens tokenize expression
      compiled += '\n'
    #TODO FIX THIS PROPERLY, DIRTY HACK
    compiled = compiled.replace /;{2,}/g, ';'
    input.val "#{input.val()}\n #{COMPILE_START_STRING}\n#{compiled}"
  $('#save').popover
    placement: 'bottom'
    title: 'Choose a name'
    trigger: 'manual'
    content: '<input type="text" id="filename">'
  $('#save').click ->
    $(@).popover 'toggle'
    $('#filename').keydown saveCode
  input.keydown (e) ->
    if e.which is KEYS.TAB
      e.preventDefault()
      old = input.val()
      currentPosition = input.getCursorPosition()
      input.val old.slice(0,currentPosition) + '\t' + old.slice(currentPosition)
  dropDown = $ '#dropdown'
  for codeSnippet of localStorage
    dropDown.append "<li><a href='#'>#{codeSnippet}</a></li>"
  dropDown.children().click loadCode


loadCode = (e) ->
  code = localStorage.getItem @.firstChild.text
  $('#input').val code

saveCode = (e) ->
  if e.which is KEYS.ENTER
    dropDown = $ '#dropdown'
    filename = $(@)
    code = $('#input').val()
    localStorage.setItem filename.val(), code
    $('#save').popover 'hide'
    dropDown.append "<li><a href='#'>#{filename.val()}</a></li>"
    dropDown.children().click loadCode
    filename.val ''

splitExpression = ->
  expressions = $('#input').val()
  if expressions.indexOf(COMPILE_START_STRING) isnt -1
    expressions = expressions.substring 0, expressions.indexOf COMPILE_START_STRING
  k = 0
  expressionStart = 0
  openBrackets = 0
  closedBrackets = 0
  expressionList = []
  while k < expressions.length
    if expressions.charAt(k) is '('
      openBrackets += 1
      if openBrackets is 1 and closedBrackets is 0
        expressionStart = k
    if expressions.charAt(k) is ')' then closedBrackets += 1
    k += 1
    if openBrackets > 0 and openBrackets is closedBrackets
      expr = expressions.slice expressionStart, k
      expressionList.push expr
      openBrackets = 0
      closedBrackets = 0
  expressionList

mouseDown = (e) ->
  repl = $ '#console'
  e.preventDefault()
  textlength = repl.val().length
  if not repl.is ':focus'
    repl.setCursorPosition textlength, textlength


newLine = false
keyDown = do ->
  expressionLines = []
  expressionCache = []
  currentCacheIndex = 0
  lastKey = undefined
  (e) ->
    newLine = false
    repl = $ '#console'
    history = repl.val()
    checkForEnd = ->
      position = repl.getCursorPosition()
      if position <= 2 or history.slice(position-3, position) is '\n> '
        e.preventDefault()

    switch e.which
      when KEYS.UP
        if currentCacheIndex is -1
          currentCacheIndex = expressionCache.length - 1
        lastCache = expressionCache[currentCacheIndex]
        if lastCache
          lastLine = repl.val().split('\n').pop()
          cache = "#{history.slice(0, history.lastIndexOf(lastLine))}> #{lastCache.trim()}"
          repl.val cache
          currentCacheIndex -= 1
        e.preventDefault()
      when KEYS.LEFT
        checkForEnd()
      when KEYS.BACKSPACE
        checkForEnd()
      when KEYS.ENTER
        lastLine = repl.val().split('\n').pop()
        lastLine = lastLine.replace '> ', ''
        expressionLines.push lastLine+ ' '
        completeExpression = expressionLines.reduce (a,b) -> a + b
        if isBracketBalanced completeExpression
          expressionCache.push completeExpression
          currentCacheIndex = expressionCache.length - 1
          tokens = tokenize completeExpression
          parsed = parseTokens tokens
          try
            result = evalExpression parsed
            if result? then repl.val "#{history}\n#{result.toString()}"
          catch error
            repl.val "#{history}\n#{error.toString()}"
          newLine = true
          expressionLines = []
      when KEYS.C
        if lastKey is KEYS.CTRL
          e.preventDefault()
          repl.val history + '\n> '
          expressionLines = []
    lastKey = e.which

keyUp = (e) ->
  repl = $ '#console'
  if newLine
    history = repl.val()
    repl.val history + '> '
    window.FIRST_PRINT = true

isBracketBalanced = (string) ->
  openingBrackets = string.split('(').length - 1
  closingBrackets = string.split(')').length - 1
  openingBrackets <= closingBrackets

# EXOPRTS
window.FIRST_PRINT = true
