class @Search
  constructor: (@templates = {}) ->

  remove_fields: (button) ->
    $(button).closest('.fields').remove()

  add_fields: (button, type, content) ->
    new_id = new Date().getTime()
    regexp = new RegExp('new_' + type, 'g')
    $(button).after(content.replace(regexp, new_id))
