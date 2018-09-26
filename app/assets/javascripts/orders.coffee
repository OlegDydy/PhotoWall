# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$( -> 
  $("#gallery").click( ->
    $("#gallery").hide()
  )

  $(".card-body img").click( ->
    if this.getAttribute('full_size')
      $("#gallery img")[0].src = this.getAttribute('full_size')
    else
      $("#gallery img")[0].src = this.src
    $("#gallery").show()
  )
)