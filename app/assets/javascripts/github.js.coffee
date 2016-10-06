(($) ->

  displayUser = (options) ->

    loading = () ->
      $('#loading').removeClass('hidden')
      $('#results').find('li').remove()

    callback = (data) ->
      buildLink = (item) ->
        $('<a />').attr('target', '_blank').attr('href', item.html_url).html(item.name)
      $('#loading').addClass('hidden')
      if data.error
        $('#results').html($('<span />').html('Error: ' + data.error))
      else
        $.each data, (i, item) ->
          $('#results').append($('<li />').html(buildLink(item)))

    $.ajax
        url: options.url,
        type: 'GET',
        data: options.data,
        beforeSend: (jqXHR, PlainObject) ->
          loading()
        success: (data, textStatus, jqXHR) ->
          callback(data)

  $(document).ready ->
    $('form.github-input').submit (e) ->
      e.preventDefault()
      displayUser url: $(e.target).attr('action'), data: { user: { name: $('#user').val() } }

)(jQuery)