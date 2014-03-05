window.App ||= {}
class App.Transitions

  constructor: ->
    $('.trading-floor-link').off('click').on 'click', ->
      $(document).on 'page:fetch', ->
        $('.main').addClass('animated fadeOutLeft').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
          $(this).removeClass('animated fadeOutLeft')
          return

      $(document).on 'page:change', ->
        $('.main').addClass('animated fadeInRight').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
          $(this).removeClass('animated fadeInRight')
          return

      return

    return