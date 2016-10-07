(($) ->

  window.initGithub = (options) ->
    if options.name
      displayUser url: options.url, data: { n: options.name, page: options.page }
    $('form.github-input').submit (e) ->
      e.preventDefault()
      displayUser url: options.url, data: { n: $('#user').val(), page: 1 }

  displayUser = (options) ->
    $.ajax
        url: options.url,
        type: 'GET',
        data: options.data,
        beforeSend: (jqXHR, PlainObject) ->
          $('#loading').removeClass('hidden')
          $('#results').html('')
        success: (data, textStatus, jqXHR) ->
          $('#loading').addClass('hidden')
          if data.error
            $('#results').html($('<span />').html('Error: ' + data.error))
          else
            $('#results').html(data)

)(jQuery)