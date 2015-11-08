
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'datagrid_plugin', 'imageView'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

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
            field: 'lastOperator'
            title: '最后操作人信息'
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
              "<a href=\"javascript:jAlert('#{info}', '最后操作人信息')\">#{data?.value?.username}</a>"
          }, {
            field: 'modified'
            title: '最后修改时间'
            render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
          }, {
            field: 'goodsVo'
            title: '商品信息'
            render: (data)->
              info =
                "<p>商品名称　　#{data?.value?.name}</p>" +
                "<p>商品编码　　#{data?.value?.barcode}</p>" +
                "<p>危险品　　　#{if data?.value?.hazardFlag then '是' else '否'}</p>" +
                "<p>商品体积　　#{data?.value?.volume}</p>" +
                "<p>商品重量　　#{data?.value?.weight}</p>" +
                "<p>计量单位　　#{data?.value?.uom}</p>" +
                "<p>所属品牌　　#{data?.value?.brandVo?.name}</p>" +
                "<p>所属种类　　#{data?.value?.categoryVo?.name}</p>" +
                "<p>所属库位　　#{data?.value?.locationVo?.name}</p>"
              "<a href=\"javascript:jAlert('#{info}', '商品信息')\">#{data?.value?.name}</a>"
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
          }
        ]
      })
