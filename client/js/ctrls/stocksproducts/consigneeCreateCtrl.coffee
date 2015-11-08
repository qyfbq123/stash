
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  supplierData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/consigneeCreate.html', supplierData)

      isNew = window.location.hash.endsWith('consigneeAdd')
      if isNew
        for k, v of supplierData.attr()
          supplierData.removeAttr(k)
        localStorage.rm 'tmpConsigneeInfo'
      else
        tmpConsigneeInfo = localStorage.get 'tmpConsigneeInfo'
        supplierData.attr(tmpConsigneeInfo)

      $('#createConsignee').unbind 'click'
      $('#createConsignee').bind 'click', ()->
        return if !$('#consigneeCreate').valid()

        supplierData.attr('companyVo', Auth.user().companyVo)
        url = Auth.apiHost +  if isNew then 'goods/consignee/create' else 'goods/consignee/update'

        $.postJSON(url, supplierData.attr(),
          (data)->
            for k, v of supplierData.attr()
              supplierData.removeAttr(k)

            if data.status == 0
              supplierData.attr({})
              if isNew then jAlert "新增收货人成功！", "提示" else jAlert "更新收货人成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
