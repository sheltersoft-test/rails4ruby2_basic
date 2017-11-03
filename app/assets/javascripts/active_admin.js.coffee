#= require active_admin/base
#= require active_admin/base

$(document).ready ->
  if $('#resource_resource_holder_type').length > 0
    resourceHolderType = $('#resource_resource_holder_type')
    resourceHolderType.change (e) ->
      selectedValue = resourceHolderType.val()
      if selectedValue
        $.ajax
          url: '/resources/get_resource_holders'
          method: 'GET'
          data: 'resource_holder_type': selectedValue
          success: (result) ->
            options = '<option value=\'\'></option>'
            result['resource_holders'].forEach (resource_holder) ->
              option = '<option value=' + resource_holder['id'] + '>' + resource_holder['name'] + '</option>'
              options += option
              return
            $('#resource_resource_holder_id').html options
            return
      return

  if $('.has_many_container.place').length > 0
    place = $('.has_many_container.place')
    if $(place.find('fieldset')).length > 0
      place.find('.has_many_add').hide()

      if (place.find('*[id^="_place_attributes__destroy"]').length == 0)
        place.find('.has_many_remove').show()
      else
        place.find('.has_many_remove').hide()

    $(place.find('.has_many_add')).click ->
      place.find('.has_many_add').hide()
      return

    $('.has_many_container.place').on 'click', '.has_many_remove', ->
      place.find('.has_many_add').show()
      return

  if $('.has_many_container.user_role').length > 0
    user_roles = $('.has_many_container.user_role')
    if $(user_roles.find('fieldset')).length > 0
      user_roles.find('.has_many_add').hide()

      if (user_roles.find('*[id^="_user_role_attributes__destroy"]').length == 0)
        user_roles.find('.has_many_remove').show()
      else
        user_roles.find('.has_many_remove').hide()

    $(user_roles.find('.has_many_add')).click ->
      user_roles.find('.has_many_add').hide()
      return

    $('.has_many_container.user_role').on 'click', '.has_many_remove', ->
      user_roles.find('.has_many_add').show()
      return
