define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'autocomplete', 'dateTimePicker', 'datagrid_plugin', 'printer'], (base, can, Control, Auth, localStorage)->
  listData = new can.Map()
  goodsData = new can.Map()
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
        serviceUrl: "#{Auth.apiHost}mywms2/goods/supplier/allbyname"
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
        serviceUrl: "#{Auth.apiHost}mywms2/goods/all"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          currentData = suggestion.data
      })

      itemIds = []
      datagrid = $('#goodsInList').datagrid({
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
              old = listData.attr id
              old.attr 'count', parseInt($(idSel)[0].value)
              listData.attr id, old
          $('.datagrid-page').empty()
        col:[{
            attrHeader: { "style": "width:200px;"},
            field: 'name'
            title: '商品名称'
          }, {
            attrHeader: { "style": "width:100px;"},
            field: 'barcode'
            title: '商品编号'
          },{
            field: 'photos'
            title: '商品图片'
            attrHeader: {'class': 'notPrint'}
            attr: {'class': 'notPrint'}
            render: (data)->
              imgs = _.map(data.value, (img)->img.path = "#{Auth.apiHost}mywms2/goods/photo?path=#{img.path}"; img)
              itemImgsInfo = {id: data.row.id, imgs: imgs}
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
              "<input type='number' value=#{data.value} id=itemId#{data.row.id} min:'1', required>"
          },{
            attrHeader: { "style": "width:50px;", 'class': 'notPrint'},
            attr: {'class': 'notPrint'}
            field: ''
            title: '操作'
            render: (data)->
              "<a href='' class='table-actions-button ic-table-delete' alt='删除'></a>"
          }
        ]
      })

      $('#addToGoodsList').unbind('click')
      $('#addToGoodsList').bind 'click', ()->
        return if !$('#goodsInCreate').valid()

        currentData.count = $('#goodCount')[0].value
        old = listData.attr(currentData.id)

        if old
          currentData.count = parseInt(old.count) + parseInt(currentData.count)
          listData.attr(currentData.id, currentData)
        else
          listData.attr(currentData.id, currentData)
        vs = _.values(listData.attr())

        $('#goodsInList').datagrid('render', {total:vs.length, data:vs})

        $('#goodSelector')[0].value = ''
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
          count = it.count
          delete it.count
          return {
            goodsVo: it,
            quantity: count
          }
        ))

        url = Auth.apiHost + 'mywms2/stock/in/create'
        $.postJSON(url, goodsData.attr(),
          (data)->
            if data.status == 0
              goodsData.attr({})
              listData.attr({})
              jAlert "新增出货单成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
