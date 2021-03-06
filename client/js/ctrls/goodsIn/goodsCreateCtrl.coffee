listData = new can.Map()
goodsData = new can.Map()

deleteGoodsInListItem = (item)->
  listData.removeAttr(item.id)

  vs = _.values(listData.attr())
  $('#goodsInList').datagrid('render', {total:vs.length, data:vs})


define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'autocomplete', 'dateTimePicker', 'datagrid_plugin', 'printer'], (base, can, Control, Auth, localStorage)->
  goodsData.attr('entries', listData)
  currentData = {}

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/goodsIn/goodsCreate.html', goodsData)

      $('#goodsInDate').datetimepicker
        timepicker: false
        lang: 'zh'

      $('#supplierSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/supplier/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          goodsData.attr('supplierVo', suggestion.data)
          $('#supplierSelector').attr('value', suggestion.data.name)
      })

      $('#goodSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/all"
        paramName: 'factor'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.sku} --- #{it.name}", data: it})
        onSelect: (suggestion)->
          currentData.good = suggestion.data
      })

      $('#locationSelector').autocomplete({
        minChars:0
        noCache: true
        serviceUrl: "#{Auth.apiHost}location/findusable"
        paramName: 'name'
        params: {goodsId:()-> currentData?.good?.id || ''}
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          currentData.location = suggestion.data
      })
      $('#goodSelector').bind 'change', ()->
        currentData.good = {} if !$('#goodSelector')[0].value

      itemIds = []
      datagrid = $('#goodsInList').datagrid({
        data: []
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        onBefore: ()->
          itemIds = []
        onComplete: ()->
          for id in itemIds
            idSel = "#itemId#{id}"
            $(idSel).change (oldValue, newValue)->
              old = listData.attr id
              old.attr 'count', parseInt($(idSel)[0].value)
              listData.attr id, old
          $('.datagrid-page').empty()
        col:[{
            attrHeader: { "style": "width:150px;"},
            field: 'good'
            title: 'SKU'
            render: (data)-> data.value.sku
          }, {
            attrHeader: { "style": "width:200px;"},
            field: 'good'
            title: '商品名称'
            render: (data)-> data.value.name
          }, {
            attrHeader: { "style": "width:100px;"},
            field: 'good'
            title: '条形码'
            render: (data)-> data.value.barcode
          }, {
            field: 'location'
            title: '放置库位'
            render: (data)-> data.value.name
          }, {
            field: 'good'
            title: '商品图片'
            attrHeader: {'class': 'notPrint'}
            attr: {'class': 'notPrint'}
            render: (data)->
              imgs = _.map(data.value.photos, (img)->img.path = "#{Auth.apiHost}goods/photo?path=#{img.path}"; img)
              itemImgsInfo = {id: data.value.id, imgs: imgs}
              html = ''
              for img in imgs
                html += "<li><a href='#{img.path}'><img src='#{img.path}'></a></li>"

              html = "<ul class='gallery'>
                        <li>
                          <ul id='photo#{data.value.id}' class='gallery'>
                            #{html}
                          </ul>
                        </li>
                      </ul>"
          },{
            attrHeader: { "style": "width:30px;"},
            field: 'good'
            title: '数量'
            render: (data)->
              itemIds.push data.value.id
              "<input type='number' value=#{data.value.count} id=itemId#{data.value.id} min:'1', required>"
          },{
            attrHeader: { "style": "width:50px;", 'class': 'notPrint'},
            attr: {'class': 'notPrint'}
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:deleteGoodsInListItem(#{JSON.stringify(data.row.good)});void(0);' class='table-actions-button ic-table-delete' alt='删除'></a>"
          }
        ]
      })

      $('#addToGoodsList').unbind('click')
      $('#addToGoodsList').bind 'click', ()->
        return if !$('#goodsInCreate').valid()

        currentData.good.count = $('#goodCount')[0].value
        newId = "#{currentData.good.id}|#{currentData.location.id}"
        old = listData.attr(newId)

        if old and old.location.id == currentData.location.id
          currentData.good.count = parseInt(old.good.count) + parseInt(currentData.good.count)
          listData.attr(newId, currentData)
        else
          listData.attr(newId, currentData)
        vs = _.values(listData.attr())

        $('#goodsInList').datagrid('render', {total:vs.length, data:vs})

        $('#goodSelector')[0].value = ''
        $('#locationSelector')[0].value = ''
        $('#goodCount')[0].value = 1

      $('#printGoodsList').unbind 'click'
      $('#printGoodsList').bind 'click', ()->
        $('#printArea').print(noPrintSelector: 'a,button,.notPrint')

      $('#createGoodsList').unbind 'click'
      $('#createGoodsList').bind 'click', ()->
        return if !$('#goodsInCreate').valid()

        goodsData.attr('date', Date.parse(goodsData.attr('date')))
        goodsData.attr('companyVo', Auth.user().companyVo)
        goodsData.attr('creatorVo', Auth.user())
        goodsData.attr('entries', _.map(_.values(listData.attr()), (it)->
          count = it.good.count
          delete it.good.count
          return {
            goodsVo: it.good,
            locationVo: it.location
            quantity: count
          }
        ))

        url = Auth.apiHost + 'stock/in/create'
        $.postJSON(url, goodsData.attr(),
          (data)->
            if data.status == 0
              goodsData.attr({})
              listData.attr({})
              jAlert "新增进货单成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
