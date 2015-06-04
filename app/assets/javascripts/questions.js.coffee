$ ->
  $('a.copy_to_clipboard').zclip
    path: '/js/ZeroClipboard.swf'
    copy: ->
      return $(this).closest('tr').find('td.content').attr('title')
    afterCopy: ->
      # 占位，否则默认会有alert弹出

  $('#edit_auto_submodel_modal').on 'change', 'select.auto_brand_select', ->
    that = this
    $.get '/auto_brands/' + $(this).val() + '/auto_models', (data)->
      $(that).closest('.modal').find('select.auto_model_select').html(data)

  $('#edit_auto_submodel_modal').on 'change', 'select.auto_model_select', ->
    that = this
    $.get '/auto_models/' + $(this).val() + '/auto_submodels', (data)->
      $(that).closest('.modal').find('select.auto_submodel_select').html(data)
