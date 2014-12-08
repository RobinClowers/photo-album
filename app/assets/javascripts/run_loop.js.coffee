class @RunLoop
  @funcs: []

  @register: (fn) ->
    RunLoop.funcs.push fn

  @run: ->
    fn() for fn in RunLoop.funcs

setInterval(RunLoop.run, 100)
