$(document).on 'emoji:ready', ->
  $(".input-search").focus()
  $(".loading").remove()

  # Check for Flash
  hasFlash = false
  try
    hasFlash = Boolean(new ActiveXObject('ShockwaveFlash.ShockwaveFlash'))
  catch exception
    hasFlash = ('undefined' != typeof navigator.mimeTypes['application/x-shockwave-flash'])

  if not hasFlash || navigator.userAgent.match(/iPad|iPhone/i)
    $(document).on 'click', '.emoji-code', ->
      this.selectionStart = 0
      this.selectionEnd = this.value.length
  else
    clip = new ZeroClipboard( $("[data-clipboard-text]"),{ moviePath: "/assets/zeroclipboard.swf"} )
    clip.on "complete", (_, args) -> $("<div class=alert></div>").text("Copied " + args.text).appendTo("body").fadeIn().delay(1000).fadeOut()
    $(".emoji-code").attr("readonly", "readonly")

focusOnSearch = (e) ->
  if e.keyCode == 191 && !$(".input-search:focus").length
    $(".input-search").focus()
    t = $(".input-search").get(0)
    if t.value.length
      t.selectionStart = 0
      t.selectionEnd = t.value.length
    false

$.getJSON 'emojis.json', (emojis) ->
  container = $('.emojis-container')
  $.each emojis, (name, keywords) ->
    container.append "<li class='result emoji-wrapper' data-clipboard-text=':#{name}:'>
      <div class='emoji s_#{name.replace(/\+/,'')}' title='#{name}'>#{name}</div>
      <input type='text' class='autofocus plain emoji-code' value=':#{name}:' />
      <span class='keywords'>#{name} #{keywords}</span>
      </li>"
  $(document).trigger 'emoji:ready'

$(document).keydown (e) -> focusOnSearch(e)

$(document).on 'keydown', '.emoji-wrapper input', (e) ->
  $(".input-search").blur()
  focusOnSearch(e)

$(document).on 'click', '[data-clipboard-text]', ->
  ga 'send', 'event', 'copy', $(this).attr('data-clipboard-text')

$(document).on 'click', '.js-hide-text', ->
  $('.emojis-container').toggleClass('hide-text')
  showorhide = if $('.emojis-container').hasClass('hide-text') then 'hide' else 'show'
  ga 'send', 'event', 'toggle text', showorhide
  false

$(document).on 'click', '.js-clear-search, .mojigroup.active', ->
  location.hash = ""
  false

$(document).on 'click', '.js-contribute', ->
  ga 'send', 'event', 'contribute', 'click'
