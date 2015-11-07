
define ['base', 'can', 'can/control', 'Auth', 'localStorage', 'autocomplete', 'tokenize', '_', 'jAlert'], (base, can, Control, Auth, localStorage, autocomplete, tokenize)->
  userInfo = new can.Map()

  return Control.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/company/userNew.html', userInfo)

      selectedRole = []
      @isNewUser = window.location.hash.endsWith('userAdd')

      getRole = (companyId, done)->
        success = (data)->
          $('#roleSelector').empty()
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
          done?()
        error = (data)->
          selectedRole = []
          userInfo.attr('roleVoList', selectedRole)
          el = $('#roleSelector').tokenize().clear()
          done?()
        $.getJSON("#{Auth.apiHost}mywms2/company/rolelist", companyId: companyId, success, error)

      # 新增
      # 修改
      if @isNewUser
        for k, v of userInfo.attr()
          userInfo.removeAttr(k)
        localStorage.rm 'tmpUserInfo'
      else
        tmpUserInfo = localStorage.get 'tmpUserInfo'

        if tmpUserInfo
          $('#companySelector').attr('disabled', 'disabled')
          selectedRole = _.map(tmpUserInfo.roleVoList, (it)->id: it.id)
          userInfo.attr(tmpUserInfo);
          userInfo.attr('companyVo', {id:tmpUserInfo.companyVo.id})

          getRole tmpUserInfo.companyVo.id, ()->
            for role in tmpUserInfo.roleVoList
              $('#roleSelector').tokenize().tokenAdd(role.id, role.name)

      $('#newUser').unbind('click')
      $('#newUser').bind 'click', ()->
        return if !$('#userNew').valid()

        tmpUserInfo = localStorage.get 'tmpUserInfo'
        url = Auth.apiHost + if tmpUserInfo then 'mywms2/user/update' else 'mywms2/user/create'

        userInfo.attr('roleVoList', _.map(userInfo.attr('roleVoList'), (role)-> id:parseInt(role.id)))
        userInfo.attr('roleVoList', _.uniq(userInfo.attr('roleVoList'), (role)-> parseInt(role.id)))

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

      # 非系统用户只可以使用本公司
      if Auth.user().companyVo.issystem != 1
        $('#companySelector').attr('disabled', 'disabled')
        userInfo.attr('companyVo', {id:Auth.user().companyVo.id})
        getRole(Auth.user().companyVo.id)
      else
        $('#companySelector').autocomplete({
          minChars:0
          serviceUrl: "#{Auth.apiHost}mywms2/company/allbyname"
          paramName: 'name'
          dataType: 'json'
          transformResult: (response, originalQuery)->
            query: originalQuery
            suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
          onSelect: (suggestion)->
            userInfo.attr('companyVo', {id:suggestion.data})
            getRole(suggestion.data)
        });
