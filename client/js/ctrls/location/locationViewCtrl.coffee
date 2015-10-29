define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  locationData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/location/locationView.html', locationData)

      datagrid = $('#locationList').datagrid({
        url: Auth.apiHost + 'mywms2/location/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap"
        paramsDefault: {paging:10}
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
            title: '库位名称'
          }, {
            field: 'created'
            title: '创建时间'
            render: (data)-> new Date(data.value).toLocaleString()
          },{
            field: 'modfied'
            title: '最近修改'
            render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
          },{
            field:'usage'
            title:'已使用'
          },{
            field: 'xcoord'
            title: '所在行'
          },{
            field: 'ycoord'
            title: '所在列'
          },{
            field: 'zcoord'
            title: '所在层'
          },{
            field: 'warehouseVo'
            title: '仓库信息'
            render: (data)->
              info =
                "<p>仓库名称&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>仓库地址&nbsp;&nbsp;&nbsp;#{data?.value?.address}</p>" +
                "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactName}</p>" +
                "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.value?.contactTel}</p>" +
                "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.value?.contactEmail}</p>" +
                "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactQq}</p>" +
                "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.value?.contactFax}</p>" +
                "<p>联系MSN&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn}</p>"
              "<a href=\"javascript:jAlert('#{info}', '仓库信息')\">#{data?.value?.name}</a>"
          },{
            field: 'companyVo'
            title: '公司信息'
            render: (data)->
              info =
                "<p>公司名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
                "<p>公司地址&nbsp;&nbsp;&nbsp;#{data?.value?.address}</p>" +
                "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactName}</p>" +
                "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.value?.contactTel}</p>" +
                "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.value?.contactEmail}</p>" +
                "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactQq}</p>" +
                "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.value?.contactFax}</p>" +
                "<p>联系MSN&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn}</p>"
              "<a href=\"javascript:jAlert('#{info}', '公司信息')\">#{data?.value?.name}</a>"
          }
        ]
      })
