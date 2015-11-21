
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'datagrid_plugin', 'imageView', 'autocomplete'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()
  selCompanyId = ''

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/stock.html', brandData)

      itemIds =  []
      $('#stockList').datagrid({
        url: Auth.apiHost + 'stock/inventory/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        parse: (data)->
          return {total:data.total, data: data.rows}
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
        col:[{
            field: 'locked'
            title: '选择'
            render: (data)->
              "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
          }, {
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
            title: '商品数量'
          }, {
            field: 'goodsVo'
            title: '商品图片'
            attrHeader: { "style": "width:40%;"},
            render: (data)->
              itemIds.push data.row.id
              imgs = _.map(data?.value?.photos, (img)->img.path = "#{Auth.apiHost}goods/photo?path=#{img.path}"; img)
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
          }
        ]
      })

      $('#stockList').datagrid( "filters", $('#filterSelector'));

      $('#goodSel').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/all"
        paramName: 'factor'
        params:{companyId:()->selCompanyId || ''}
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.sku} --- #{it.name}", data: it.id})
        onSelect: (suggestion)->
          $('#stockList').datagrid( "fetch", {goodsId: suggestion.data});
      })
      if(Auth.user().companyVo.issystem)
        $('#companySel').autocomplete({
          minChars:0
          serviceUrl: "#{Auth.apiHost}company/allbyname"
          paramName: 'name'
          dataType: 'json'
          transformResult: (response, originalQuery)->
            query: originalQuery
            suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
          onSelect: (suggestion)->
            $('#stockList').datagrid( "fetch", {companyId:suggestion.data});
            selCompanyId = suggestion.data
        });
        $('#companySel').bind 'change',  ()->
          selCompanyId = '' if !$('#companySel')[0].value
      else $('#filterSelector .companySel').empty()
      $('#locationSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}location/allbyname"
        paramName: 'name'
        params:{companyId:()->selCompanyId || ''}
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
        onSelect: (suggestion)->
          $('#stockList').datagrid( "fetch", {locationId:suggestion.data});
      })
