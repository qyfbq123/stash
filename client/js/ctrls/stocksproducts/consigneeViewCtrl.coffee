clickConsigneeUpdate = (data)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpConsigneeInfo', data
    window.location.hash = "#!home/stocksproducts/consigneeAdd/#{data.id}"

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  consigneeData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/stocksproducts/consigneeView.html', consigneeData)

      datagrid = $('#consigneeList').datagrid({
        url: Auth.apiHost + 'mywms2/goods/consignee/page',
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
              "<a href='javascript:clickConsigneeUpdate(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'name'
            title: '供应商名称'
          }, {
            field: 'address'
            title: '供应商地址'
          },{
            field: 'desc'
            title: '供应商描述'
          },{
            field:'contactName'
            title:'联系人'
          },{
            field: 'contactTel'
            title: '联系人号码'
          },{
            field: 'contactEmail'
            title: '联系人邮箱'
          },{
            field: 'contactMsn'
            title: '联系人MSN'
          },{
            field: 'contactFax'
            title: '联系人传真'
          },{
            field: 'contactDesc'
            title: '联系人描述'
          }
        ]
      })
