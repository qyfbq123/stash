clickSupplierUpdate = (data)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpSupplierInfo', data
    window.location.hash = "#!home/stocksproducts/supplierAdd/#{data.id}"

clickDeleteSupplier = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'goods/supplier/delete', {supplierId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  supplierList = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/stocksproducts/supplierView.html', supplierList)

      datagrid = $('#supplierList').datagrid({
        url: Auth.apiHost + 'goods/supplier/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
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
              "<a href='javascript:clickSupplierUpdate(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='javascript:clickDeleteSupplier(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
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

      $('#supplierList').datagrid( "filters", $('#filterSelector'));
