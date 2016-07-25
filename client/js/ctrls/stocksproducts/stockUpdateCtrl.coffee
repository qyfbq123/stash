define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  pageData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      isNew = window.location.hash.endsWith('stock')
      if isNew
        localStorage.rm 'tmpStockData'
      else
        tmpStockData = localStorage.get 'tmpStockData'
        console.log tmpStockData
        pageData.attr 'stockData', tmpStockData
        companyVo = Auth.user().companyVo
        aliasArr = [1..6].map (k)->
          companyVo["udf#{k}Alias"] || "参数#{k}"
        pageData.attr 'aliasArr', aliasArr

      this.element.html can.view('../public/view/home/stocksproducts/stockUpdate.html', pageData)

      $('#saveStock').click ->
        url = "#{Auth.apiHost}stock/inventory/update"
        $.postJSON(url, pageData.attr('stockData').attr(),
          (data)->

            if data.status == 0
              for k, v of pageData.attr()
                pageData.removeAttr(k)
                
              localStorage.rm 'tmpStockData'
              jAlert "参数修改成功！", "提示"
              history.go -1
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )