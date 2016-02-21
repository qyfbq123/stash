
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  supplierData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/supplierCreate.html', supplierData)

      isNew = window.location.hash.endsWith('supplierAdd')
      if isNew
        for k, v of supplierData.attr()
          supplierData.removeAttr(k)
        localStorage.rm 'tmpSupplierInfo'
      else
        tmpSupplierInfo = localStorage.get 'tmpSupplierInfo'
        supplierData.attr(tmpSupplierInfo)

      $('#createSupplier').unbind 'click'
      $('#createSupplier').bind 'click', ()->
        return if !$('#supplierCreate').valid()

        supplierData.attr('companyVo', Auth.user().companyVo)
        url = Auth.apiHost + if isNew then 'goods/supplier/create' else 'goods/supplier/update'

        $.postJSON(url, supplierData.attr(),
          (data)->
            if data.status == 0

              for k, v of supplierData.attr()
                supplierData.removeAttr(k)
              supplierData.attr({})
              if isNew then jAlert "新增供应商成功！", "提示" else jAlert "更新供应商成功！", "提示"
              window.location.hash = '#!home/stocksproducts/supplierView'
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
