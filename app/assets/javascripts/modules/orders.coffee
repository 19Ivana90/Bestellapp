jQuery ($) ->
  $(document).on 'ready page:load', ->
    $(document).on 'click', '#edit-cart', (event) ->
      event.preventDefault()

      $('#cart').addClass('editing')

    $(document).on 'click', '#cancel-edit-cart', (event) ->
      event.preventDefault()

      $('#cart').removeClass('editing')

    $(document).on 'click', '#update-cart', (event) ->
      event.preventDefault()

      $('form.edit_order').submit()
