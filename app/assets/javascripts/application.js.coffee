#= require jquery
#= require jquery_ujs
#= require twitter/bootstrap
#= require turbolinks
#= require twitter/typeahead
#= require_tree .

$(document).on "ready page:change", ->
  
  if $("body").data("environment") != "test"
    # Remove all global properties set by addthis, otherwise it won't reinitialize
    for i of window
      delete window[i]  if /^addthis/.test(i) or /^_at/.test(i)
    window.addthis_share = null
    
    # Finally, load addthis
    $.getScript "https://s7.addthis.com/js/250/addthis_widget.js#pubid=ra-526425ac0ea0780b"
