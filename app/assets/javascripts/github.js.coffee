(($) ->

  window.initGithub = (options) ->
    if options.name
      displayUser url: options.url, data: { user: { name: options.name }, page: options.page }
    $('form.github-input').submit (e) ->
      e.preventDefault()
      displayUser url: options.url, data: { user: { name: $('#user').val() }, page: 1 }

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
        $.each data.results, (i, item) ->
          $('#results').find('ul').append($('<li />').html(buildLink(item)))

        $('#pagination').html('')

        if data.page > 1
          $('#pagination').append(
            $('<a />').attr('href',
              "/?" + $.param({ user: $('#user').val(), page: data.page - 1 })
            ).html("< Prev").addClass('margin-10')
          )

        if data.page < data.total_pages
          $('#pagination').append(
            $('<a />').attr('href',
              "/?" + $.param({ user: $('#user').val(), page: data.page + 1 })
            ).html("Next >").addClass('margin-10')
          )

    $.ajax
        url: options.url,
        type: 'GET',
        data: options.data,
        beforeSend: (jqXHR, PlainObject) ->
          loading()
        success: (data, textStatus, jqXHR) ->
          callback(data)

  $(document).ready ->

)(jQuery)