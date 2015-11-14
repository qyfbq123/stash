
define ['base', 'can', 'can/control', 'Auth', 'localStorage', 'fileInputZh', '_', 'jAlert', 'validate', 'autocomplete'], (base, can, Control, Auth, localStorage, fileInputZh)->
  stockItemData = new can.Map()
  pageData = new can.Map()
  dataData = new can.Map()
  stockItemData.attr 'page', pageData
  stockItemData.attr 'data', dataData

  switchStep = (step)->
    if step == 1
      pageData.attr('StepCreate', 'block')
      pageData.attr('StepUploadImage', 'none')
    else
      pageData.attr('StepCreate', 'none')
      pageData.attr('StepUploadImage', 'block')

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      switchStep 1
      this.element.html can.view('../../public/view/home/stocksproducts/stockItemCreate.html', stockItemData)

      isNew = window.location.hash.endsWith('stockItemAdd')
      if isNew
        for k, v of dataData.attr()
          dataData.removeAttr(k)
        localStorage.rm 'tmpStockItemData'
      else
        tmpStockItemData = localStorage.get 'tmpStockItemData'
        dataData.attr(tmpStockItemData)
        dataData.attr('brandVo', tmpStockItemData.brandVo)
        dataData.attr('categoryVo', tmpStockItemData.categoryVo)
        dataData.attr('locationVo', tmpStockItemData.locationVo)
        $('#brandSelector').attr('value', tmpStockItemData.brandVo?.name)
        $('#categorySelector').attr('value', tmpStockItemData.categoryVo?.name)
        $('#locationSelector').attr('value', tmpStockItemData.locationVo?.name)

      $('#brandSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/brand/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          dataData.attr('brandVo', suggestion.data)
      });

      $('#categorySelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/category/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          dataData.attr('categoryVo', suggestion.data)
      });

      $('#locationSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}location/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          dataData.attr('locationVo', suggestion.data)
      })

      doUpload = (id)->
        jConfirm '上传商品图片？', '提示', (yeOrNo)->
          $("#filePicker").fileinput({
            language: 'zh'
            maxFileCount: 10
            minImageWidth: 10
            minImageHeight: 10
            maxFileSize: 5 * 1024
            uploadUrl: "#{Auth.apiHost}goods/photo/upload?goodsId=#{id}"
            allowedFileExtensions: ["jpeg", "jpg", "png", "gif"]
            slugCallback: (name)-> name
          });
          $('#filePicker').on 'filebatchuploadsuccess', ()->
            dataData.attr({})
            jAlert '图片上传成功！', '提示'
            # switchStep 1

          $('#filePicker').on 'filebatchuploaderror', ()->
            jAlert '图片上传失败！', '提示'

          switchStep 2

      $('#createStockItem').unbind 'click'
      $('#createStockItem').bind 'click', ()->
        return if !$('#stockItemCreate').valid()
        dataData.attr('companyVo', Auth.user().companyVo)

        url = Auth.apiHost + if isNew then 'goods/create' else 'goods/update'
        $.postJSON(url, dataData.attr(),
          (data)->
            for k, v of dataData.attr()
              dataData.removeAttr(k)

            if data.status == 0
              dataData.attr({})
              if isNew
                jAlert "新增商品成功！", "提示"
                doUpload(data.data.id)
              else
                jAlert "更新商品成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
