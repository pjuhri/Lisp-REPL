typeCheck = (functionName, args, type) ->
  for arg,index in args
    if arg.type isnt type
      throw "#{functionName}: expects type <#{type}> as #{index} argument, given: #{arg.type}"

BUILTINS =
  '+': new Lisp.Procedure('+', 'Number', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value + b.value)
  '-': new Lisp.Procedure('-', 'Number', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value - b.value)
  '*': new Lisp.Procedure('*', 'Number', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value * b.value)
  '/': new Lisp.Procedure('/', 'Number', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value / b.value)
  '>': new Lisp.Procedure('>', 'Number', (args) ->
        if args[0] > args[1] then Lisp.True else Lisp.False)
  '>=': new Lisp.Procedure('>=', 'Number', (args) ->
        if args[0] >= args[1] then Lisp.True else Lisp.False)
  '<': new Lisp.Procedure('<', 'Number', (args) ->
        if args[0] < args[1] then Lisp.True else Lisp.False)
  '<=': new Lisp.Procedure('<=', 'Number', (args) ->
        if args[0] <= args[1] then Lisp.True else Lisp.False)
  'eq?': new Lisp.Procedure('eq?', 'Any', (args) ->
        if args[0].type is 'Number'
          if args[0].value is args[1].value then return Lisp.True else return Lisp.False
        if args[0] is args[1] then Lisp.True else Lisp.False)
  'type?': new Lisp.Procedure('type?', 'Any', (args) ->
        new Lisp.Symbol args[0].type)
  'and': new Lisp.Procedure('and', 'Boolean', (args) ->
          if args.every( (x) -> x is Lisp.True) then Lisp.True else Lisp.False)
  'or': new Lisp.Procedure('or', 'Boolean', (args) ->
          if args.some( (x) -> x is Lisp.True) then Lisp.True else Lisp.False)
  'not': new Lisp.Procedure('not', 'Boolean', (args) ->
          if args[0] is Lisp.True then Lisp.False else Lisp.True)
  'cons': new Lisp.Procedure('cons', 'Any', (args) -> new Lisp.Cons args[0], args[1])
  'first': new Lisp.Procedure('first', 'Cons', (args) -> args[0].first)
  'rest': new Lisp.Procedure('rest', 'Cons', (args) -> args[0].rest)
  'last': new Lisp.Procedure('last', 'Cons', (args) ->
                              check = (list) ->
                                if list.rest is Lisp.Nil then list.first else check list.rest
                              check args[0])
  'print': new Lisp.Procedure('print', 'Any', (args) ->
            repl = $ '#console'
            if window.FIRST_PRINT
              repl.val "#{repl.val()}\n#{args[0].toString()}"
              window.FIRST_PRINT = false
            else
              repl.val "#{repl.val()}#{args[0].toString()}"
            return)

class Environment
  constructor: (parms=[], args=[], @parent=null) ->
    for parm,index in parms
      @[parm.value] = args[index]

  find: (value) ->
    try
      if value of @ then @[value] else @parent.find value
    catch error
      throw "reference to undefined identifier: #{value}"

  findEnvironment: (value) ->
    try
      if value of @ then @ else @parent.findEnvironment value
    catch error
      throw "set!: cannot set variable before its definition: #{value}"

  updateValues: (values) ->
    for key,value of values
      @[key] = value


globalEnvironment = new Environment
globalEnvironment.updateValues BUILTINS

evalExpression = (expression, env=globalEnvironment) ->
    if expression.type is 'JList'
      switch expression[0].value
        when 'define'
          [_, variable, expr...] = expression
          if variable.type is 'JList'
            #the alternative lambda syntax was used
            name = variable[0]
            expr.unshift new Lisp.Symbol 'begin'
            env[name.value] = new Lisp.Procedure name.value, 'Any',
              (args) -> evalExpression expr, new Environment variable[1..], args, env
          else
            env[variable.value] = evalExpression expr[0], env
        when 'lambda'
          [_, variables, expr] = expression
          new Lisp.Procedure 'lambda', 'Any',
            (args) -> evalExpression expr, new Environment variables, args, env
        when 'if'
          [_, testExpr, ifExpr, elseExpr] = expression
          expr = if evalExpression(testExpr,env) is Lisp.True then ifExpr else elseExpr
          evalExpression expr, env
        when 'let'
          [_, tupels, expr] = expression
          vars = []
          vals = []
          for x in tupels
            vars.push x[0]
            vals.push evalExpression x[1], env
          evalExpression expr, new Environment vars, vals, env
        when 'set!'
          [_, variable, value] = expression
          targetEnvironment = env.findEnvironment variable.value
          targetEnvironment[variable.value] = evalExpression value, env
        when 'begin'
          expressions = expression[1..]
          (evalExpression expr, env for expr in expressions).pop()

        else #run procedure
          evaluated = (evalExpression x,env for x in expression)
          procedure = evaluated.shift()
          procedure(evaluated)
    else if expression.type is 'Symbol'
      env.find(expression.value)
    else if expression.type is 'Quoted'
      expression.value
    else
      expression

window.evalExpression = evalExpression
window.globalEnvironment = globalEnvironment
window.resetGlobalEnvironment = ->
  globalEnvironment = new Environment
  globalEnvironment.updateValues BUILTINS
