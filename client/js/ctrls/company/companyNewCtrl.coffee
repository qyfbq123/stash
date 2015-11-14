
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  userInfo = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      # 新增
      # 修改
      @isNewUser = window.location.hash.endsWith('companyAdd')
      if @isNewUser
        for k, v of userInfo.attr()
          userInfo.removeAttr(k)
        localStorage.rm 'tmpCompanyInfo'
      else
        tmpCompanyInfo = localStorage.get 'tmpCompanyInfo'
        if tmpCompanyInfo
          userInfo.attr(tmpCompanyInfo);

      this.element.html can.view('../../public/view/home/company/companyNew.html', userInfo)

      $('#saveCompany').unbind 'click'
      $('#saveCompany').bind 'click', ()->

        return if !$('#newClient').valid()

        url = Auth.apiHost + if tmpCompanyInfo then 'company/update' else 'company/create'

        $.postJSON(url, userInfo.attr(),
          (data)->
            for k, v of userInfo.attr()
              userInfo.removeAttr(k)

            if data.status == 0
              localStorage.rm 'tmpCompanyInfo'
              userInfo.attr({})
              if !tmpCompanyInfo
                jAlert "新增公司成功！", "提示"
              else
                jAlert "更新公司成功！", "提示"
              window.location.hash = '#!home/company/companyView'
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
