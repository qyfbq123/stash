
define ['can/control', 'can', 'Auth', 'datagrid_plugin'], (Ctrl, can, Auth)->
  PAGE_ZIE = 20

  userList = new can.Map

  getUser = (pageNum, pageSize)->
    $.getJSON(Auth.apiHost + 'mywms2/user/page', {page: pageNum, rows: pageSize}
      , (data)->
        console.log data
        # $('.easyui-pagination').pagination({total:data.total, pageSize:PAGE_ZIE})
        # $('#users').datagrid data:data
      , (data)->
        # $.messager.alert '错误', "http error: #{data.status}, #{data.statusText}"
    )

  return Ctrl.extend
    init: ()->
      this.element.html can.view('../../public/view/home/user-management.html', userList)

      datagrid = $('#userList').datagrid({
        url: Auth.apiHost + 'mywms2/user/page',
        parse: (data)->
          return {total:5, data: data.rows}
        col:[{
            field: 'locked'
            title: '启用'
            render: (value)->
              "<input type='checkbox' name='DataGridCheckbox' checked=#{value == 0 ? 'checked' : 'unchecked'}>"
          },{
            field: 'cname'
            title: '用户别名'
            width: 100
          }, {
            field: 'username'
            title: '用户名'
            width: 100
          },
          {
            field: 'created'
            title: '创建'
            width: 100
            render: (data)-> new Date(data.value).toLocaleString()
          },{
            field:'clientVo'
            title:'客户名'
            width:100
            render: (data)-> return data?.value?.name || ''
          },{
            field: 'tel'
            title: '联系号码'
            width: 100
          },{
            field: 'address'
            title: '用户地址'
            width: 120
          },{
            field: 'roleVoList'
            title: '角色'
            width: 120
            render: (data)->
              roleNameList = _.pluck data.value, 'name'
              return roleNameList.join(',')
          }
        ]
        sorter: "bootstrap",
        pager: "bootstrap"
      })

      # $('#mainLayout').layout();
      # $('#contentLayout').layout();

      # $('#users').datagrid({
      #   columns:[[
      #     {
      #       field: 'locked'
      #       title: '启用'
      #       formatter: (value, row)->
      #         "<input type='checkbox' name='DataGridCheckbox' checked=#{value == 0 ? 'checked' : 'unchecked'}>"
      #     },{
      #       field: 'cname'
      #       title: '用户别名'
      #       width: 100
      #     }, {
      #       field: 'username'
      #       title: '用户名'
      #       width: 100
      #     },
      #     {
      #       field: 'created'
      #       title: '创建'
      #       width: 100
      #       formatter: (value, row)-> return new Date(row.created).toLocaleString()
      #     },{
      #       field:'clientVo'
      #       title:'客户名'
      #       width:100
      #       formatter: (value,row,index)-> return value?.name || ''
      #     },{
      #       field: 'tel'
      #       title: '联系号码'
      #       width: 100
      #     },{
      #       field: 'address'
      #       title: '用户地址'
      #       width: 120
      #     },{
      #       field: 'roleVoList'
      #       title: '角色'
      #       width: 120
      #       formatter: (value, row)->
      #         roleNameList = _.pluck value, 'name'
      #         return roleNameList.join(',')
      #     }
      #   ]]
      # });

      # getUser 0, 20

    '#addUserBtn click': ()->
      new newUserCtrl('#dialog', {})
