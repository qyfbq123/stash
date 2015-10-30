
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/brandCreate.html', brandData)

      isNew = window.location.hash.endsWith('brandAdd')
      if isNew
        for k, v of brandData.attr()
          brandData.removeAttr(k)
        localStorage.rm 'tmpBrandInfo'
      else
        tmpBrandInfo = localStorage.get 'tmpBrandInfo'
        brandData.attr(tmpBrandInfo)

      $('#newBrand').unbind 'click'
      $('#newBrand').bind 'click', ()->
        return if !$('#brandNew').valid()

        brandData.attr('companyVo', Auth.user().companyVo)
        url = Auth.apiHost + if isNew then 'mywms2/goods/brand/create' else 'mywms2/goods/brand/update'
        $.postJSON(url, brandData.attr(),
          (data)->
            for k, v of brandData.attr()
              brandData.removeAttr(k)

            if data.status == 0
              if isNew then jAlert "新增品牌成功！", "提示" else jAlert "更新品牌成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
