
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  warehouseData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/location/warehouseAdd.html', warehouseData)

      $('#addWarehouse').unbind 'click'
      $('#addWarehouse').bind 'click', ()->
        return if !$('#warehouseAdd').valid()

        url = Auth.apiHost +  'mywms2/location/warehouse/create'
        $.postJSON(url, warehouseData.attr(),
          (data)->
            for k, v of warehouseData.attr()
              warehouseData.removeAttr(k)

            if data.status == 0
              warehouseData.attr({})
              jAlert "新增仓库成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
