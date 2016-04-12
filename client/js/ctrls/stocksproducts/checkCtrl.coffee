
define ['can/control', 'can', 'Auth', 'base', 'localStorage', 'datagrid_plugin', 'jAlert', 'autocomplete', 'imageView'], (Ctrl, can, Auth, base, localStorage)->
  return Ctrl.extend
    init: (el, data)->
      new base('', data) if !can.base
      this.element.html can.view('../../public/view/home/stocksproducts/check.html', {})

      startAt = Date.now()
      checkList = localStorage.get('checkList') || []
      itemIds =  []
      window.clickDeleteCheckGoods = (item)->
        checkList = _.without(checkList, _.findWhere(checkList, {id: item.id}))
        localStorage.set 'checkList', checkList
        $('#checkGrid').datagrid('render', {total:checkList.length, data:checkList})

      $('#addCheck').unbind 'click'
      $('#addCheck').bind 'click', ()->
        grouped = _.countBy checkList, (it)->
          it.locationVo.name

        for k, v of grouped
          if v > 1
            return jAlert "空闲库位 #{k} 多次使用！", "错误"

        entries = _.map checkList, (it)->
          if isNaN it.id
            {quantity: it.quantity, checkQuantity: it.checkQuantity || it.quantity, itemId: it.goodsVo.id, locationId: it.locationVo.id}
          else
            {inventoryId: it.id, quantity: it.quantity, checkQuantity: it.checkQuantity}
        data = {startAt, entries}
        $.postJSON("#{Auth.apiHost}inventory/check", data,
          (data)->
            if data.status == 0
              localStorage.remove 'checkList'
              jAlert "盘点完毕！", "提示"
              window.location.hash = '#!home/stocksproducts/stock'
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert data.responseText, "错误"
        )

      $('#checkGrid').datagrid({
        data: checkList
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        onBefore: ()->
          itemIds = []
        onComplete: ()->
          for id in itemIds
            $("#photo#{id}").magnificPopup({
              delegate: 'a'
              type: 'image'
              gallery:
                enabled: true
            })

            doCheck = (id)->
              $("#check#{id}").bind 'change', ()->
                checkQuantity = parseInt($("#check#{id}")[0].value)
                checkList = _.map checkList, (it)->
                  return it if it.id != id

                  it.checkQuantity = checkQuantity
                  return it

            doCheck id
        col:[
          {
            field: 'op'
            title: '操作'
            render: (data)->
              "<a href='javascript:clickDeleteCheckGoods(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
          }, 
          {
            field: 'goodsVo'
            title: 'SKU'
            render: (data)->
              info =
                "<p>SKU&nbsp;　　　#{data?.value?.sku}</p>" +
                "<p>商品名称　　#{data?.value?.name}</p>" +
                "<p>条形码　　#{data?.value?.barcode}</p>" +
                "<p>危险品　　　#{if data?.value?.hazardFlag then '是' else '否'}</p>"
              "<a href=\"javascript:jAlert('#{info}', '商品信息');void(0);\">#{data?.value?.sku}</a>"
          }, {
            field: 'goodsVo'
            title: '商品名称'
            render: (data)->
              return data?.value?.name
          }, {
            field: 'quantity'
            title: '数量'
          }, {
            field: 'quantity'
            title: '盘点数量',
            render: (data)->
              "<input type='number' value=#{data.row.quantity} id=\"check#{data.row.id}\">"
          }, {
            field: 'goodsVo'
            title: '商品图片'
            render: (data)->
              itemIds.push data.row.id
              imgs = _.map(data?.value?.photos, (img)->img.path = "#{img.path}"; img)
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
          }, {
            field: 'lastOperator'
            title: '最后操作人'
            render: (data)->
              roleNameList = _.pluck data.roleVoList, 'name'
              info =
                "<p>用户名　　　#{data?.value?.username}</p>" +
                "<p>用户别名　　#{data?.value?.cname}</p>" +
                "<p>用户地址　　#{data?.value?.address}</p>" +
                "<p>用户角色　　#{roleNameList}</p>" +
                "<p>所属公司　　#{data?.value?.companyVo?.name || '无'}</p>" +
                "<p>创建时间　　#{if data?.value?.created then new Date(data.value.created).toLocaleString() else '无'}</p>" +
                "<p>电话号码　　#{data?.value?.tel || ''}</p>"
              "<a href=\"javascript:jAlert('#{info}', '最后操作人信息');void(0);\">#{data?.value?.username}</a>"
          }, {
            field: 'modified'
            title: '最后修改时间'
            render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
          }, {
            field: 'locationVo'
            title: '库位信息'
            render: (data)->
              return '无' if !data.value
              info =
                "<p>库位名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>XCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.xcoord}</p>" +
                "<p>YCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.ycoord}</p>" +
                "<p>ZCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.zcoord}</p>"

              "<a href=\"javascript:jAlert('#{info}', '库位信息');void(0);\">#{data?.value?.name}</a>"
          }, {
            field: 'inVo',
            title: '批次',
            render: (data)->
              return '无' if !data.value
              inVo = data.value
              udf = []
              for i in [1...6]
                udf.push( inVo["udf#{i}"] ) if inVo["udf#{i}"]
              info =
                """
                <p>订单编号　　　#{inVo.billnumber}</p>
                <p>客户订单编号　#{inVo.customerBillnumber}</p>
                <p>自定义参数　　#{udf.join(', ') || ''}</p>
                """
              "<a href=\"javascript:jAlert('#{info}', '批次信息');void(0);\">#{inVo.billnumber}</a>"
          }
        ]
      })
      
      $('#goodsSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/all"
        paramName: 'factor'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.sku} --- #{it.name}", data: it})
        onSelect: (suggestion)->
          # $('#stockList').datagrid( "fetch", {goodsId: suggestion.data});
          $('#goodsSelector').data 'item', suggestion.data
      })

      $('#locationSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}location/findusable"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          # $('#stockList').datagrid( "fetch", {locationId:suggestion.data});
          $('#locationSelector').data 'location', suggestion.data
      })

      $('#addNew').unbind('click').bind 'click', (e)->
        $('#tmpAddDialog').removeClass 'hide'
        
        e.stopPropagation()
        e.preventDefault()

      $('#tmpAddDialog').on 'click', 'a.button', (e)->
        e.stopPropagation()
        e.preventDefault()
        console.log 'com'
        if( $(this).is '.ic-add' )
          item = $('#goodsSelector').data 'item'
          location = $('#locationSelector').data 'location'
          return jAlert '请选择一个商品！', '错误' if !item
          return jAlert '请选择一个库位！', '错误' if !location

          if item.photos
            _.map item.photos, (img)->
              img.path = "#{Auth.apiHost}goods/photo?path=#{img.path}" unless img.path.indexOf('http') == 0
              img

          inventory = 
            id: "temp#{Date.now()}"
            goodsVo: item
            quantity: 1
            lastOperator: Auth.user()
            companyVo: Auth.user().companyVo
            locationVo: location

          checkList.push inventory
          localStorage.set 'checkList', checkList
          $('#checkGrid').datagrid('render', {total:checkList.length, data:checkList})

        $('#tmpAddDialog').addClass 'hide'
        $('#goodsSelector').val('')
        $('#locationSelector').val('')
        $('#goodsSelector').removeData 'item'
        $('#locationSelector').removeData 'location'
