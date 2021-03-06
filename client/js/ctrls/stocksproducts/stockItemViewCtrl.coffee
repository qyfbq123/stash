manageImgs = (data)->
  require ['imageManageCtrl'], (imageManageCtrl)->
    $('#stockItemList').attr('style', 'display:none;')
    new imageManageCtrl '#imageManager', data

clickUpdateStock = (data)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpStockItemData', data
    window.location.hash = "#!home/stocksproducts/stockItemAdd/#{data.id}"

clickDeleteStockItem = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'goods/delete', {goodsId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'imageView', 'imageManageCtrl', 'autocomplete'], (Ctrl, can, Auth, base)->
  consigneeData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/stocksproducts/stockItemView.html', consigneeData)

      itemIds =  []
      datagrid = $('#stockItemList').datagrid({
        url: Auth.apiHost + 'goods/page',
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

        parse: (data)->
          return {total:data.total, data: data.rows}
        col:[{
            field: 'locked'
            title: '选择'
            render: (data)->
              "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
          },{
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:clickUpdateStock(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='javascript:clickDeleteStockItem(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'sku'
            title: 'SKU'
          }, {
            field: 'name'
            title: '商品名称'
          }, {
            field: 'barcode'
            title: '条形码'
          },{
            field: 'photos'
            title: '商品图片'
            render: (data)->
              itemIds.push data.row.id
              imgs = _.map(data.value, (img)->img.path = "#{Auth.apiHost}goods/photo?path=#{img.path}"; img)
              itemImgsInfo = {id: data.row.id, imgs: imgs}
              html = ''
              for img in imgs
                html += "<li><a href='#{img.path}'><img src='#{img.path}'></a></li>"

              html = "<ul class='gallery'>
                        <li>
                          <a title='图片管理' href='javascript:manageImgs(#{JSON.stringify(itemImgsInfo)});void(0);'>
                            <button class='btnImage'></button>
                          </a>
                        <li>
                        <li>
                          <ul id='photo#{data.row.id}' class='gallery'>
                            #{html}
                          </ul>
                        </li>
                      </ul>"
          },{
            field: 'hazardFlag'
            title: '危险品'
            render: (data)-> if data.value then '是' else '否'
          },{
            field: 'volume'
            title: '商品体积'
          },{
            field:'weight'
            title:'商品重量'
          },{
            field: 'uom'
            title: '计量单位'
          },{
            field: 'brandVo'
            title: '所属品牌'
            render: (data)->
              info =
                "<p>品牌名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>创建时间&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.created}</p>" +
                "<p>最近修改&nbsp;&nbsp;&nbsp;&nbsp;#{if data?.value?.modfied then new Date(data?.value?.modfied).toLocaleString() else '无'}</p>"

              "<a href=\"javascript:jAlert('#{info}', '品牌信息');void(0);\">#{data?.value?.name}</a>"
          },{
            field: 'categoryVo'
            title: '种类信息'
            render: (data)->
              info =
                "<p>种类名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>种类描述&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.desc}</p>"

              "<a href=\"javascript:jAlert('#{info}', '种类信息');void(0);\">#{data?.value?.name}</a>"
          }
        ]
      })

      $('#stockItemList').datagrid( "filters", $('#filterSelector'));

      $('#brandSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}goods/brand/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          $('#stockItemList').datagrid( "fetch", {brandId:suggestion.data.id, factor:$('#factor')[0].value});
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
          $('#stockItemList').datagrid( "fetch", {categoryId:suggestion.data.id, factor:$('#factor')[0].value});
      });
