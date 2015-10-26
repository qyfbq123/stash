
define ['base', 'can', 'can/control', 'Auth', 'localStorage', 'autocomplete', 'tokenize', '_', 'jAlert'], (base, can, Control, Auth, localStorage, autocomplete, tokenize)->
  userInfo = new can.Map()

  return Control.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      tmpUserInfo = localStorage.get 'tmpUserInfo'
      if tmpUserInfo
        userInfo.attr(tmpUserInfo);

      this.element.html can.view('../../public/view/home/company/userNew.html', userInfo)

      $('#newUser').unbind('click')
      $('#newUser').bind 'click', ()->
        tmpUserInfo = localStorage.get 'tmpUserInfo'
        url = Auth.apiHost + if tmpUserInfo then 'mywms2/user/update' else 'mywms2/user/create'

        console.log userInfo.attr()

        success = (data)->
          for k, v of userInfo.attr()
            userInfo.removeAttr(k)

          if data.status == 0
            localStorage.rm 'tmpUserInfo'
            userInfo.attr({})
            if !tmpUserInfo
              jAlert "新增用户成功！", "提示"
            else
              jAlert "更新用户成功！", "提示"
            window.location.hash = '#!home/company/userAdd'
          else
            jAlert "#{data.message}", "提示"

        error = (data)->
          jAlert "错误", data.responseText

        $.postJSON(url, userInfo.attr(), success, error)


      selectedRole = []
      selectedCompany = null
      if Auth.user().companyVo.issystem != 1
        selectedCompany = {id:Auth.user().companyVo.id}
        userInfo.attr('companyVo', {id:selectedCompany.id})
        getRole(selectedCompany.id)
      else
        $('#companySelector').autocomplete({
          serviceUrl: "#{Auth.apiHost}mywms2/company/allbyname"
          paramName: 'name'
          dataType: 'json'
          transformResult: (response, originalQuery)->
            query: originalQuery
            suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
          onSearchComplete: (e)->
            selectedCompany = null
            userInfo.attr('companyVo', null)
          onSelect: (suggestion)->
            selectedCompany = {id:suggestion.data}
            userInfo.attr('companyVo', {id:selectedCompany.id})
            getRole(selectedCompany.id)
        });

      getRole = (companyId)->
        success = (data)->
          for company in data
            $('#roleSelector').append("<option value='#{company.id}'>#{company.name}</option>")

          el = $('#roleSelector').tokenize({
            displayDropdownOnFocus: true
            onAddToken: (value, text, e)->
              selectedRole = _.union selectedRole, [id:value]
              userInfo.attr('roleVoList', selectedRole)
            onRemoveToken: (value, e)->
              selectedRole = _.reject selectedRole, (it)-> it.id == value
              userInfo.attr('roleVoList', selectedRole)
          })
        error = (data)->
          selectedRole = []
          userInfo.attr('roleVoList', selectedRole)
          el = $('#roleSelector').tokenize().clear()

        $.getJSON("#{Auth.apiHost}mywms2/company/rolelist", companyId: companyId, success, error)
