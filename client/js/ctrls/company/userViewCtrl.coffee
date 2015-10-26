define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  userList = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      this.element.html can.view('../../public/view/home/company/userView.html', userList)

      datagrid = $('#userList').datagrid({
        url: Auth.apiHost + 'mywms2/user/page',
        parse: (data)->
          return {total:5, data: data.rows}
        col:[{
            field: 'locked'
            title: '启用'
            render: (data)->
              "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
          },{
            field: 'username'
            title: '用户名'
          },{
            field: 'cname'
            title: '用户别名'
          },{
            field: 'created'
            title: '创建'
            render: (data)-> new Date(data.value).toLocaleString()
          },{
            field: 'tel'
            title: '联系号码'
          },{
            field: 'address'
            title: '用户地址'
          },{
            field: 'roleVoList'
            title: '角色'
            render: (data)->
              roleNameList = _.pluck data.value, 'name'
              return roleNameList.join(',')
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
        sorter: "bootstrap",
        pager: "bootstrap"
      })

    '#addUserBtn click': ()->
