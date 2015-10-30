
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'autocomplete'], (base, can, Control, Auth, localStorage)->
  locationData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/location/locationAdd.html', locationData)

      $('#warehouseSelector').autocomplete({
        serviceUrl: "#{Auth.apiHost}mywms2/location/warehouse/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          locationData.attr('warehouseVo', suggestion.data)
      });

      $('#companySelector').autocomplete({
        serviceUrl: "#{Auth.apiHost}mywms2/company/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          locationData.attr('companyVo', suggestion.data)
      });

      # 新增
      # 修改
      isNewLocation = window.location.hash.endsWith('locationAdd')
      if isNewLocation
        for k, v of locationData.attr()
          locationData.removeAttr(k)
        localStorage.rm 'tmpLocationInfo'
      else
        tmpLocationInfo = localStorage.get 'tmpLocationInfo'
        locationData.attr(tmpLocationInfo)
        $('#warehouseSelector').attr('value', tmpLocationInfo.warehouseVo.name)
        $('#companySelector').attr('value', tmpLocationInfo.companyVo.name)
        $('#warehouseSelector').attr('disabled', 'disabled')
        $('#companySelector').attr('disabled', 'disabled')

      $('#addLocation').unbind 'click'
      $('#addLocation').bind 'click', ()->
        return if !$('#locationAdd').valid()

        url = Auth.apiHost +  if isNewLocation then 'mywms2/location/create' else 'mywms2/location/update'

        $.postJSON(url, locationData.attr(),
          (data)->
            for k, v of locationData.attr()
              locationData.removeAttr(k)

            if data.status == 0
              locationData.attr({})
              if isNewLocation then jAlert "新增库位成功！", "提示" else jAlert "新增库位成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
