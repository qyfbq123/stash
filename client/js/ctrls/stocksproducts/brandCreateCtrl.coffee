
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/brandCreate.html', brandData)

      $('#newBrand').unbind 'click'
      $('#newBrand').bind 'click', ()->
        return if !$('#brandNew').valid()

        brandData.attr('companyVo', Auth.user().companyVo)
        url = Auth.apiHost + 'mywms2/goods/brand/create'
        $.postJSON(url, brandData.attr(),
          (data)->
            for k, v of brandData.attr()
              brandData.removeAttr(k)

            if data.status == 0
              jAlert "新增品牌成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
