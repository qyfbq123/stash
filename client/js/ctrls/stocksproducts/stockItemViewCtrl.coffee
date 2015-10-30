define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'imageView'], (Ctrl, can, Auth, base)->
  consigneeData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/stocksproducts/stockItemView.html', consigneeData)

      imageIds =  []
      datagrid = $('#stockItemList').datagrid({
        url: Auth.apiHost + 'mywms2/goods/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap"
        paramsDefault: {paging:10}
        onBefore: ()->
          imageIds = []
        onComplete: ()->
          for id in imageIds
            console.log "#photo#{id}"
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
            title: '启用'
            render: (data)->
              "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
          },{
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:clickCompanyUpdate(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'name'
            title: '商品名称'
          }, {
            field: 'barcode'
            title: '商品编号'
          },{
            field: 'photos'
            title: '商品图片'
            render: (data)->
              imageIds.push data.row.id
              imgs = _.map(data.value, (img)->"#{Auth.apiHost}mywms2/goods/photo/#{img}")
              html = ''
              for img in imgs
                html += "<li><a href='#{img}'><img src='#{img}'></a></li>"
              html = "<ul id='photo#{data.row.id}' class='gallery'>#{html}</ul>"
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

              "<a href=\"javascript:jAlert('#{info}', '品牌信息')\">#{data?.value?.name}</a>"
          },{
            field: 'categoryVo'
            title: '种类信息'
            render: (data)->
              info =
                "<p>种类名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>种类描述&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.desc}</p>"

              "<a href=\"javascript:jAlert('#{info}', '种类信息')\">#{data?.value?.name}</a>"
          },{
            field: 'locationVo'
            title: '库位信息'
            render: (data)->
              info =
                "<p>库位名称&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>库位创建&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.created}</p>" +
                "<p>最近修改&nbsp;&nbsp;&nbsp;&nbsp;#{if data?.value?.modfied then new Date(data?.value?.modfied).toLocaleString() else '无'}</p>" +
                "<p>已经使用&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.locked}</p>" +
                "<p>所在行  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.xcoord}</p>" +
                "<p>所在列  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.ycoord}</p>" +
                "<p>所在层  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.zcoord}</p>"

              "<a href=\"javascript:jAlert('#{info}', '库位信息')\">#{data?.value?.name}</a>"
          }
        ]
      })
