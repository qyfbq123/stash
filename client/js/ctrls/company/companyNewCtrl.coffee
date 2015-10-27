
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert'], (base, can, Control, Auth, localStorage)->
  userInfo = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      tmpCompanyInfo = localStorage.get 'tmpCompanyInfo'
      if tmpCompanyInfo
        userInfo.attr(tmpCompanyInfo);

      this.element.html can.view('../../public/view/home/company/companyNew.html', userInfo)

      $('#save').unbind 'click'
      $('#save').bind 'click', ()->
        url = Auth.apiHost + if tmpCompanyInfo then 'mywms2/company/update' else 'mywms2/company/create'

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
