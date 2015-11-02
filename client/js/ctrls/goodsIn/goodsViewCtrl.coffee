clickCompanyUpdate = (info)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpGoodsViewInfo', info
    window.location.hash = "#!home/goodsIn/goodsInAdd/#{info.id}"

define ['can/control', 'can/view/mustache', 'Auth', 'base', 'datagrid_plugin'], (Ctrl, can, Auth, base)->
  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      this.element.html can.view('../../public/view/home/goodsIn/goodsView.html', {})

      datagrid = $('#goodsInList').datagrid({
        url: Auth.apiHost + 'mywms2/stock/in/page',
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
            title: '公司名称'
          }, {
            field: 'address'
            title: '公司地址'
          },{
            field: 'desc'
            title: '公司描述'
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
