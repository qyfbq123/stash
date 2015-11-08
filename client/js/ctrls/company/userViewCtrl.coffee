clickUserUpdate = (info)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpUserInfo', info
    window.location.hash = "#!home/company/userAdd/#{info.id}"

clickDeleteUser = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'user/delete', {userId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  userList = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      this.element.html can.view('../../public/view/home/company/userView.html', userList)

      datagrid = $('#userList').datagrid({
        url: Auth.apiHost + 'user/page',
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
            field: 'op'
            title: '操作'
            render: (data)->
              "<a href='javascript:clickUserUpdate(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='javascript:clickDeleteUser(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-delete'></a>"
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
      })
