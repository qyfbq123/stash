
define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'autocomplete', 'validate'], (Ctrl, can, Auth, base)->
  pageData = new can.Map(original: {}, target: {})
  return Ctrl.extend
    init: (el, data)->
      new base('', data) if !can.base
      this.element.html can.view('../../public/view/home/stocksproducts/migrate.html', pageData)

      original = null
      target = null

      $('#targetSelector').attr('disabled', 'disabled')
      $('#originalSelector').unbind 'change'
      $('#originalSelector').bind 'change', ()->
        if $('#originalSelector')[0].value == ''
          target = null
          original = null
          $('#targetSelector')[0].value = ''
          pageData.attr('original', {})
          pageData.attr('target', {})
          $('#targetSelector').attr('disabled', 'disabled')
      $('#originalSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}inventory/all"
        paramName: 'factor'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.locationVo.name} - #{it.goodsVo.sku} - #{it.goodsVo.name}", data: it})
        onSelect: (suggestion)->
          original = suggestion.data
          pageData.attr('original', original)
          $('#targetSelector').removeAttr('disabled', 'null')
      })

      $('#targetSelector').unbind 'change'
      $('#targetSelector').bind 'change', ()->
        if $('#targetSelector')[0].value == ''
          target = null
          pageData.attr('target', {})
      $('#targetSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}inventory/avaliable"
        paramName: 'factor'
        params:
          inventoryId: ()->
            if !original?.id
              jAlert '请先选择原始库位！', '提示'
            else
              original.id
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value: "#{it.locationVo.name} - #{if it.goodsVo then it.goodsVo.sku else '空闲库位'} - #{if it.goodsVo then it.goodsVo.name else '无商品'}", data: it})
        onSelect: (suggestion)->
          target = suggestion.data
          pageData.attr('target', target)
      })

      $('#migrate').unbind 'click'
      $('#migrate').bind 'click', ()->
        return if !$('#migrateForm').valid()

        if !pageData.attr('target')?.attr('goodsVo')
          pageData.attr('target')?.attr('goodsVo', pageData.attr('original').goodsVo)

        url = Auth.apiHost + 'inventory/migrate'
        $.postJSON(url, pageData.attr(),
          (data)->
            if data.status == 0
              pageData.attr({})
              jAlert "转移库位成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )

