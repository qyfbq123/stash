listData = new can.Map()
goodsData = new can.Map()

cliclDeleteGoodsOutItem = (item)->
  listData.removeAttr(item.id)

  vs = _.values(listData.attr())
  $('#goodsOutList').datagrid('render', {total:vs.length, data:vs})

define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'autocomplete', 'dateTimePicker', 'datagrid_plugin', 'printer'], (base, can, Control, Auth, localStorage)->
  goodsData.attr('entries', listData)
  currentData = {}

  return Control.extend
    init: (el, data)->
      for k, v of goodsData.attr()
        goodsData.removeAttr(k)

      for k, v of listData.attr()
        listData.removeAttr(k)

      new base('', data) if !can.base

      this.element.html can.view('../public/view/home/goodsOut/goodsCreate.html', goodsData)

      $('#goodsOutDate').datetimepicker
        timepicker: false
        lang: 'zh'

      $('#consigneeSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/consignee/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          goodsData.attr('consigneeVo', suggestion.data)
          $('#consigneeSelector').attr('value', suggestion.data.name)
      })

      $('#inventorySelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}inventory/all"
        paramName: 'factor'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.goodsVo.sku}(#{it.goodsVo.name}) --- #{it.locationVo.name}#{if it.billnumber then ' --- ' + it.billnumber else ''}", data: it})
        onSelect: (suggestion)->
          currentData = suggestion.data
          $('#goodCount').bind('change', ()->
            $('#goodCount')[0].value = currentData.quantity if $('#goodCount')[0].value > currentData.quantity
          )
      })
      # $('#goodSelector').autocomplete({
      #   minChars:0
      #   serviceUrl: "#{Auth.apiHost}goods/inventory/all"
      #   paramName: 'factor'
      #   dataType: 'json'
      #   transformResult: (response, originalQuery)->
      #     query: originalQuery
      #     suggestions: _.map(response.data, (it)-> {value:"#{it.sku} --- #{it.name}", data: it})
      #   onSelect: (suggestion)->
      #     currentData = suggestion.data
      #     $('#goodCount').bind('change', ()->
      #       $('#goodCount')[0].value = currentData.quantity if $('#goodCount')[0].value > currentData.quantity
      #     )
      # })

      itemIds = []
      datagrid = $('#goodsOutList').datagrid({
        data: []
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        # pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        onBefore: ()->
          itemIds = []
        onComplete: ()->
          for id in itemIds
            idSel = "#itemId#{id}"
            $(idSel).change (oldValue, newValue)->
              max = $(this).attr 'max'
              if $(this).val() > max
                $(this).val max
              old = listData.attr id
              old.attr 'count', parseInt($(idSel)[0].value)
              listData.attr id, old
          $('.datagrid-page').empty()
        col:[ {
            attrHeader: { "style": "width:150px;"},
            field: 'goodsVo'
            title: 'SKU'
            render: (data)->
              return data?.value?.sku
          }, {
            attrHeader: { "style": "width:200px;"},
            field: 'goodsVo'
            title: '商品名称'
            render: (data)->
              return data?.value?.name
          }, {
            attrHeader: { "style": "width:100px;"},
            field: 'goodsVo'
            title: '条形码'
            render: (data)->
              return data?.value?.barcode
          }, {
            attrHeader: { "style": "width:100px;"}
            field: 'locationVo'
            title: '出货库位'
            render: (data)-> data?.value?.name
          },{
            attrHeader: { "style": "width:100px;"}
            field: 'billnumber'
            title: '批次'
          }, {
            field: 'goodsVo'
            title: '商品图片'
            attrHeader: {'class': 'notPrint'}
            attr: {'class': 'notPrint'}
            render: (data)->
              imgs = _.map(data.value?.photos, (img)->img.path = "#{Auth.apiHost}goods/photo?path=#{img.path}"; img)
              itemImgsInfo = {id: data.value.id, imgs: imgs}
              html = ''
              for img in imgs
                html += "<li><a href='#{img.path}'><img src='#{img.path}'></a></li>"

              html = "<ul class='gallery'>
                        <li>
                          <ul id='photo#{data.row.id}' class='gallery'>
                            #{html}
                          </ul>
                        </li>
                      </ul>"
          },{
            attrHeader: { "style": "width:30px;"},
            field: 'count'
            title: '数量'
            render: (data)->
              itemIds.push data.row.id
              "<input class='width60' type='number' value=#{data.value} id=itemId#{data.row.id} min=1 max=#{data.row.quantity} required>"
          },{
            attrHeader: { "style": "width:50px;", 'class': 'notPrint'},
            attr: {'class': 'notPrint'}
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:cliclDeleteGoodsOutItem(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete' alt='删除'></a>"
          }
        ]
      })

      $('#addToGoodsList').unbind('click')
      $('#addToGoodsList').bind 'click', ()->
        # return if !$('#goodsOutCreate').valid()

        currentData.count = $('#goodCount')[0].value

        old = listData.attr(currentData.id)

        if old
          currentData.count = parseInt(old.count) + parseInt(currentData.count)
          if currentData.count > currentData.quantity
            currentData.count = currentData.quantity
          listData.attr(currentData.id, currentData)
        else
          listData.attr(currentData.id, currentData)
        vs = _.values(listData.attr())

        $('#goodsOutList').datagrid('render', {total:vs.length, data:vs})

        $('#inventorySelector')[0].value = ''
        $('#goodCount')[0].value = 1

      $('#printGoodsList').unbind 'click'
      $('#printGoodsList').bind 'click', ()->
        $('#printArea').print(noPrintSelector: 'li a,button,.notPrint')

      $('#createGoodsList').unbind 'click'
      $('#createGoodsList').bind 'click', ()->
        return if !$('#goodsOutCreate').valid()

        saveDate = goodsData.attr('date')
        goodsData.attr('date', Date.parse(goodsData.attr('date')))
        goodsData.attr('companyVo', Auth.user().companyVo)
        goodsData.attr('creatorVo', Auth.user())
        goodsData.attr('entries', _.map(_.values(listData.attr()), (it)->
          count = it.count
          delete it.count
          return {
            inventoryVo: it,
            quantity: count
          }
        ))

        $('#udf input').each (i, e)->
          goodsData.attr "udf#{i+1}", $(this).val()

        url = Auth.apiHost + if isNew then 'stock/out/create' else 'stock/out/update'
        $.postJSON(url, goodsData.attr(),
          (data)->
            if data.status == 0
              for k, v of goodsData.attr()
                goodsData.removeAttr(k)

              for k, v of listData.attr()
                listData.removeAttr(k)

              $('#consigneeSelector').val ''
              goodsData.attr({})
              listData.attr({})
              if isNew
                jAlert "新增出货单成功！", "提示"
              else
                localStorage.rm 'tmpGoodsInData'
                jAlert "修改出货单成功！", "提示"
              window.location.hash = '#!home/goodsOut/goodsOutView'
            else
              goodsData.attr 'date', saveDate
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )

      $('#udfAdd').unbind('click').bind 'click', (e)->
        $('<label/>').append($ '<input type="text" class="round width300"/>' ).append($ "<a class='btn' class='btn'>删除</a>").insertBefore '#udfAdd'

        $('#udfAdd').addClass('hide') if $('#udf input').length >= 6
        e.stopPropagation()
        e.preventDefault()

      $('#udf').on 'click', 'a.btn', (e)->
        $(this).closest('label').remove()
        $('#udfAdd').removeClass 'hide'
        e.stopPropagation()
        e.preventDefault()

      isNew = window.location.hash.endsWith('goodsOutAdd')
      if isNew
        localStorage.rm 'tmpGoodsOutData'
      else
        tmpGoodsOutData = localStorage.get 'tmpGoodsOutData'
        goodsData.attr tmpGoodsOutData
        goodsData.attr 'date', new Date(tmpGoodsOutData.date).toLocaleDateString()
        $('#consigneeSelector').attr 'value', tmpGoodsOutData.consigneeVo?.name
        _.each [0...6], ->
          $('#udfAdd').click()
        _.each [1..6], (v)->
          $("#udf input:eq(#{v-1})").val tmpGoodsOutData["udf#{v}"]
        if tmpGoodsOutData.entries
          _.each tmpGoodsOutData.entries, (e)->
            tmpData = e.inventoryVo
            tmpData.count = e.quantity
            listData.attr tmpData.id, tmpData
        vs = _.values(listData.attr())

        $('#goodsOutList').datagrid('render', {total:vs.length, data:vs})
