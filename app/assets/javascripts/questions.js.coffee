$ ->
  $('a.copy_to_clipboard').zclip
    path: '/js/ZeroClipboard.swf'
    copy: ->
      return $(this).closest('tr').find('td.content').attr('title')
    afterCopy: ->
      # 占位，否则默认会有alert弹出
