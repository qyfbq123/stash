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
            $('#userList').datagrid( "fetch")
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'autocomplete'], (Ctrl, can, Auth, base)->
  userList = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      this.element.html can.view('../../public/view/home/company/userView.html', userList)

      cols = [
        # {
        #   field: 'locked'
        #   title: '选择'
        #   render: (data)->
        #     "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
        # },
        {
          attrHeader: { "style": "width:67px;"}
          field: 'op'
          title: '操作'
          render: (data)->
            "<a href='javascript:clickUserUpdate(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
            "<a href='javascript:clickDeleteUser(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
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
              "<p>联系Skype&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn}</p>"
            "<a href=\"javascript:jAlert('#{info}', '公司信息');void(0);\">#{data?.value?.name}</a>"
        }
      ]
      if !Auth.userIsAdmin()
        cols.shift(1);

      datagrid = $('#userList').datagrid({
        url: Auth.apiHost + 'user/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        parse: (data)->
          return {total:data.total, data: data.rows}
        col: cols
      })

      # $('#userList').datagrid( "filters", $('#filterSelector'));
      $('#select').bind 'click', ()->
        $('#userList').datagrid 'fetch', $('#filterSelector').serializeObject()

      if(Auth.user().companyVo.issystem)
        $('#companySelector').autocomplete({
          minChars:0
          serviceUrl: "#{Auth.apiHost}company/allbyname"
          paramName: 'name'
          dataType: 'json'
          transformResult: (response, originalQuery)->
            query: originalQuery
            suggestions: _.map(response.data, (it)->{value:it.name, data: it.id})
          onSearchStart: (query)->
            $('#companyId').val ''
          onSelect: (suggestion)->
            $('#companyId').val suggestion.data
            # $('#userList').datagrid( "fetch", {companyId:suggestion.data, factor:$('#factor')[0].value});
        });
      else
        $('#filterSelector .companySel').empty()
