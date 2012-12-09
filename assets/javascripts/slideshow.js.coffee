countdown_position = 3

countdown = ->
  $('.countdown').html(countdown_position)

  setTimeout(
    ->
      countdown_position--
      if countdown_position > 0
        countdown()
      else
        $('.countdown').remove()
        displayImage()
    , 1000
  )

displayImage = ->
  img = $('.image-loader img:first')

  if img.length == 0
    $('.slideshow').remove()
    $('.again').removeClass('hidden')
    return

  $('.slideshow').empty()
  img.clone().appendTo('.slideshow')
  img.remove()

  setTimeout(
    displayImage
    , 30
  )

$.getJSON '/photos', (data) ->
  last_image = null

  $.each data, ->
    last_image = $('<img>')
      .attr('src', this)
      .attr('width', $(window).width())
      .appendTo('.image-loader')

  last_image.load ->
    $.each $('.image-loader img'), ->
      if $(this).height() > ($(window).height() * 1.5)
        offset = ($(this).height() - $(window).height()) / 2
        $(this).css('margin-top', '-' + offset + 'px')

    $('.loading').remove()
    $('.begin').removeClass('hidden')

$('.begin').click (e) ->
  e.preventDefault()
  $('.begin').remove()
  $('.countdown').removeClass('hidden')
  countdown()

$('.again').click (e) ->
  e.preventDefault()
  location.reload()