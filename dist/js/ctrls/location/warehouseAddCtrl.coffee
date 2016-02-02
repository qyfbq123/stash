
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  warehouseData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/location/warehouseAdd.html', warehouseData)

      isNew = window.location.hash.endsWith('warehouseAdd')
      if isNew
        for k, v of warehouseData.attr()
          warehouseData.removeAttr(k)
        localStorage.rm 'tmpWarehouseInfo'
      else
        tmpWarehouseInfo = localStorage.get 'tmpWarehouseInfo'
        warehouseData.attr(tmpWarehouseInfo)

      $('#addWarehouse').unbind 'click'
      $('#addWarehouse').bind 'click', ()->
        return if !$('#warehouseAdd').valid()

        url = Auth.apiHost + if isNew then 'location/warehouse/create' else 'location/warehouse/update'
        $.postJSON(url, warehouseData.attr(),
          (data)->
            if data.status == 0

              for k, v of warehouseData.attr()
                warehouseData.removeAttr(k)
              warehouseData.attr({})
              if isNew then jAlert "新增仓库成功！", "提示" else jAlert "更新仓库成功！", "提示"
              window.location.hash = '#!home/location/warehouseView'
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
