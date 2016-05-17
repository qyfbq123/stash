
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'datagrid_plugin', 'imageView', 'autocomplete'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()
  # selCompanyId = ''

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../public/view/home/stocksproducts/stock.html', brandData)

      itemIds =  []
      originItems = []
      selectedItems = []
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

            check = (id)->
              $("#check#{id}").bind 'change', ()->
                checked = $("#check#{id}")[0].checked
                if checked
                  it = _.find(originItems, (it)-> it.id == id)
                  it.checkQuantity = it.quantity
                  arr = [it]
                  selectedItems = _.union selectedItems, arr
                else
                  selectedItems = _.reject selectedItems, (it)-> it.id == id
            check id

          $('#stockList th:gt(7)').each ()->
            if $(this).width() >= 100
              $(this).width 100
        col:[{
            field: ''
            title: '选择'
            render: (data)->
              originItems.push data.row
              "<input style='width:50px;' type='checkbox' id=\"check#{data.row.id}\"}>"
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
            title: '数量'
          }, {
            field: 'goodsVo'
            title: '图片'
            # attrHeader: { "style": "width:25%;"},
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
          }, 
          # {
          #   field: 'lastOperator'
          #   title: '最后操作人'
          #   render: (data)->
          #     roleNameList = _.pluck data.roleVoList, 'name'
          #     info =
          #       "<p>用户名　　　#{data?.value?.username}</p>" +
          #       "<p>用户别名　　#{data?.value?.cname}</p>" +
          #       "<p>用户地址　　#{data?.value?.address}</p>" +
          #       "<p>用户角色　　#{roleNameList}</p>" +
          #       "<p>所属公司　　#{data?.value?.companyVo?.name || '无'}</p>" +
          #       "<p>创建时间　　#{if data?.value?.created then new Date(data.value.created).toLocaleString() else '无'}</p>" +
          #       "<p>电话号码　　#{data?.value?.tel || ''}</p>"
          #     "<a href=\"javascript:jAlert('#{info}', '最后操作人信息');void(0);\">#{data?.value?.username}</a>"
          # }, {
          #   field: 'modified'
          #   title: '最后修改时间'
          #   render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
          # }, 
          {
            field: 'companyVo'
            title: '公司信息'
            render: (data)->
              info =
                "<p>公司名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name || ''}</p>" +
                "<p>公司地址&nbsp;&nbsp;&nbsp;#{data?.value?.address || ''}</p>" +
                "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactName || ''}</p>" +
                "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.value?.contactTel || ''}</p>" +
                "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.value?.contactEmail || ''}</p>" +
                "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactQq || ''}</p>" +
                "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.value?.contactFax || ''}</p>" +
                "<p>联系MSN&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn || ''}</p>"
              "<a href=\"javascript:jAlert('#{info}', '公司信息');void(0);\">#{data?.value?.name || ''}</a>"
          }, {
            field: 'locationVo'
            title: '库位信息'
            render: (data)->
              return '无' if !data.value
              info =
                "<p>库位名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name || ''}</p>" +
                "<p>XCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.xcoord}</p>" +
                "<p>YCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.ycoord}</p>" +
                "<p>ZCoord  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.zcoord}</p>"

              "<a href=\"javascript:jAlert('#{info}', '库位信息');void(0);\">#{data?.value?.name}</a>"
          }, {
            field: 'inVo',
            title: '批次',
            render: (data)->
              # return '无' if !data.value
              rowData = data.row
              if data.value
                inVo = data.value
                info =
                  """
                  <p>订单编号　　　#{inVo.billnumber}</p>
                  <p>客户订单编号　#{inVo.customerBillnumber}</p>
                  """
                "<a href=\"javascript:jAlert('#{info}', '批次信息');void(0);\">#{inVo.billnumber}</a>"
                # info =
                #   """
                #   <p>自定义参数　　</p>
                #   <p>　　#{rowData.companyVo.udf1Alias || '参数1'}：#{rowData.udf1 || ''}</p>
                #   <p>　　#{rowData.companyVo.udf2Alias || '参数2'}：#{rowData.udf2 || ''}</p>
                #   <p>　　#{rowData.companyVo.udf3Alias || '参数3'}：#{rowData.udf3 || ''}</p>
                #   <p>　　#{rowData.companyVo.udf4Alias || '参数4'}：#{rowData.udf4 || ''}</p>
                #   <p>　　#{rowData.companyVo.udf5Alias || '参数5'}：#{rowData.udf5 || ''}</p>
                #   <p>　　#{rowData.companyVo.udf6Alias || '参数6'}：#{rowData.udf6 || ''}</p>
                #   """
                # "<a href=\"javascript:jAlert('#{info}', '批次信息');void(0);\">缺省</a>"
          }, {
            field: 'udf1',
            title: Auth.user().companyVo.udf1Alias || '参数1'
          }, {
            field: 'udf2',
            title: Auth.user().companyVo.udf2Alias || '参数2'
          }, {
            field: 'udf3',
            title: Auth.user().companyVo.udf3Alias || '参数3'
          }, {
            field: 'udf4',
            title: Auth.user().companyVo.udf4Alias || '参数4'
          }, {
            field: 'udf5',
            title: Auth.user().companyVo.udf5Alias || '参数5'
          }, {
            field: 'udf6',
            title: Auth.user().companyVo.udf6Alias || '参数6'
          }
        ]
      })

      # $('#stockList').datagrid( "filters", $('#filterSelector'));
      $('#select').bind 'click', ()->
        $('#stockList').datagrid 'fetch', $('#filterSelector').serializeObject()

      $('#goodSel').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/all"
        paramName: 'factor'
        params:{companyId:()->$('#companyId').val() || ''}
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:"#{it.sku} --- #{it.name}", data: it.id})
        onSearchStart: (query)->
            $('#goodsId').val ''
        onSelect: (suggestion)->
          # $('#stockList').datagrid( "fetch", {goodsId: suggestion.data});
          $('#goodsId').val suggestion.data
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
          onSearchStart: (query)->
            $('#companyId').val ''
          onSelect: (suggestion)->
            # $('#stockList').datagrid( "fetch", {companyId:suggestion.data});
            $('#companyId').val suggestion.data
            # selCompanyId = suggestion.data
        });
        $('#companySel').bind 'change',  ()->
          $('#locationSelector').autocomplete()
        #   selCompanyId = '' if !$('#companySel')[0].value
      else $('#filterSelector .companySel').empty()
      $('#locationSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}location/allbyname"
        paramName: 'name'
        params:{companyId:()->$('#companyId').val() || ''}
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
        onSearchStart: (query)->
            $('#locationId').val ''
        onSelect: (suggestion)->
          # $('#stockList').datagrid( "fetch", {locationId:suggestion.data});
          $('#locationId').val suggestion.data
      })

      $('#addCheck').unbind 'click'
      $('#addCheck').bind 'click', ()->
        return jAlert '未选择任何商品！', '提示' if selectedItems.length == 0

        msg = ''
        _.each selectedItems, (e, i)->
          if e.companyVo.id != Auth.user().companyVo.id
            msg= "只可以盘点当前公司库存！#{e.goodsVo.sku}有误！"

        return jAlert msg, '错误' if msg

        oldCheckList = localStorage.get 'checkList'
        newCheckList = _.union(oldCheckList, selectedItems)
        newCheckList = _.uniq newCheckList, (it)-> it.id
        localStorage.set 'checkList', newCheckList

        jAlert '成功添加！'

