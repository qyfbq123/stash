listData = new can.Map()
goodsData = new can.Map()

deleteGoodsInListItem = (gid, lid)->
  listData.removeAttr("#{gid}_#{lid}")

  vs = _.values(listData.attr())
  $('#goodsInList').datagrid('render', {total:vs.length, data:vs})


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

      this.element.html can.view('../public/view/home/goodsIn/goodsCreate.html', goodsData)

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
          $('#goodsInCreate .udf input[name^="udf"]').val('')
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
              old.attr('good').attr('count', parseInt($(idSel)[0].value))
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
            attrHeader: { "style": "width:100px;"}
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
              itemIds.push "#{data.value.id}_#{data.row.location.id}"
              "<input class='width60' type='number' value=#{data.value.count} id=itemId#{data.value.id}_#{data.row.location.id} min:'1' required>"
          },{
            attrHeader: { "style": "width:50px;", 'class': 'notPrint'},
            attr: {'class': 'notPrint'}
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:deleteGoodsInListItem(#{data.row.good.id}, #{data.row.location.id});void(0);' class='table-actions-button ic-table-delete' alt='删除'></a>"
          }
        ]
      })

      $('#addToGoodsList').unbind('click')
      $('#addToGoodsList').bind 'click', ()->
        # return if !$('#goodsInCreate').valid()
        return if !currentData.good
        $('#goodsInCreate .udf input[name^="udf"]').each ->
          currentData[$(this).attr 'name'] = $(this).val()
        if $('#goodSelector')[0].value
          currentData.good.count = $('#goodCount')[0].value
        else
          currentData.good.count = 0
        newId = "#{currentData.good.id}_#{currentData.location.id}"
        old = listData.attr(newId)

        if old and old.location.id == currentData.location.id
          currentData.good.count = parseInt(old.good.count) + parseInt(currentData.good.count)
          listData.attr(newId, currentData)
        else
          listData.attr(newId, currentData)
        vs = _.values(listData.attr())

        $('#goodsInList').datagrid('render', {total:vs.length, data:vs})
        $('#goodsInCreate .udf input[name^="udf"]').val('')

        $('#goodSelector')[0].value = ''
        $('#locationSelector')[0].value = ''
        $('#goodCount')[0].value = 1

      $('#printGoodsList').unbind 'click'
      $('#printGoodsList').bind 'click', ()->
        $('#printArea').print(noPrintSelector: 'li a,button,.notPrint')

      $('#createGoodsList').unbind 'click'
      $('#createGoodsList').bind 'click', ()->
        return if !$('#goodsInCreate').valid()

        saveDate = goodsData.attr('date')
        goodsData.attr('date', Date.parse(goodsData.attr('date')))
        goodsData.attr('companyVo', Auth.user().companyVo)
        goodsData.attr('creatorVo', Auth.user())
        goodsData.attr('entries', _.map(_.values(listData.attr()), (it)->
          count = it.good.count
          delete it.good.count
          return {
            goodsVo: it.good
            locationVo: it.location
            quantity: count
            udf1: it.udf1
            udf2: it.udf2
            udf3: it.udf3
            udf4: it.udf4
            udf5: it.udf5
            udf6: it.udf6
          }
        ))

        url = Auth.apiHost + if isNew then 'stock/in/create' else 'stock/in/update'
        $.postJSON(url, goodsData.attr(),
          (data)->
            if data.status == 0

              for k, v of goodsData.attr()
                goodsData.removeAttr(k)

              for k, v of listData.attr()
                listData.removeAttr(k)

              $('#supplierSelector').val ''
              goodsData.attr({})
              listData.attr({})
              if isNew
                jAlert "新增进货单成功！", "提示"
              else
                localStorage.rm 'tmpGoodsInData'
                jAlert "修改进货单成功！", "提示"

              window.location.hash = '#!home/goodsIn/goodsInView'
            else
              goodsData.attr 'date', saveDate
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )


      companyVo = Auth.user().companyVo
      $('.udf input[name="udf1"]').attr 'placeholder', companyVo['udf1Alias'] || '参数1'
      $('.udf input[name="udf2"]').attr 'placeholder', companyVo['udf2Alias'] || '参数2'
      $('.udf input[name="udf3"]').attr 'placeholder', companyVo['udf3Alias'] || '参数3'
      $('.udf input[name="udf4"]').attr 'placeholder', companyVo['udf4Alias'] || '参数4'
      $('.udf input[name="udf5"]').attr 'placeholder', companyVo['udf5Alias'] || '参数5'
      $('.udf input[name="udf6"]').attr 'placeholder', companyVo['udf6Alias'] || '参数6'

      isNew = window.location.hash.endsWith('goodsInAdd')
      if isNew
        localStorage.rm 'tmpGoodsInData'
      else
        tmpGoodsInData = localStorage.get 'tmpGoodsInData'
        goodsData.attr tmpGoodsInData
        goodsData.attr 'date', new Date(tmpGoodsInData.date).toLocaleDateString()
        $('#supplierSelector').attr 'value', tmpGoodsInData.supplierVo?.name
        if tmpGoodsInData.entries
          _.each tmpGoodsInData.entries, (e)->
            tmpData =
              good: e.goodsVo
              location: e.locationVo
              udf1: e.udf1
              udf2: e.udf2
              udf3: e.udf3
              udf4: e.udf4
              udf5: e.udf5
              udf6: e.udf6
            tmpData.good.count = e.quantity
            listData.attr "#{tmpData.good.id}_#{tmpData.location.id}", tmpData
        vs = _.values(listData.attr())

        $('#goodsInList').datagrid('render', {total:vs.length, data:vs})

      $('#goodsInList').on 'click', 'tr:gt(0)', (e)->
        $('#goodsInList tr.details').removeClass 'details'
        $(this).addClass 'details'
        $('#goodSelector')[0].value = ''
        $('#locationSelector')[0].value = ''
        currentData =  _.values(listData.attr())[$(this).index()]
        $('#goodsInCreate .udf input[name^="udf"]').each ->
          $(this).val currentData[$(this).attr 'name']
