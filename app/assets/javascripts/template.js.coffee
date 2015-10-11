replace_var = (source, key, value) ->
  source.replace("{#{key}}", value)

class @Template
  @render: (template, parameters) ->
    rendered = template
    for key in Object.keys(parameters)
      rendered = replace_var(rendered, key, parameters[key])
    rendered
