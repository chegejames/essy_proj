# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ -> 
     $("<img id=ajaxloader src=/assets/ajaxloader.gif />").hide().insertBefore("#main")
     $("#ajaxloader").css({position: 'absolute', top: '30%',left: '45%', 'z-index': '100'})
     $(".invoice").on "ajax:success", (e, data, status, xhr) -> $("#invoice").html.data
     $.ready("page:fetch", $('#ajaxloader').fadeIn())
     $.ready("page:recieve", $('#ajaxloader').fadeOut())   
     $(document).on 'ajax:before ajaxStart page:fetch', -> $('#ajaxloader').fadeIn()
     $(document).on 'ajax:complete ajaxComplete page:change', -> $('#ajaxloader').fadeOut()