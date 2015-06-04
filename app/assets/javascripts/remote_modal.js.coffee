$ ->
  $('a.remote_modal_link').on 'click', (e)->
    e.preventDefault()

    url = $(this).attr('href')
    target = $(this).data('target')

    that = this
    # modal的remote参数将来会被废弃，所以这里我们自己调用jQuery的load方法
    if $(this).data('loaded') != 'true'
      $(target).find('.modal-content').load url, (response) ->
        $(that).data('loaded', 'true')

    $(target).modal('show')
