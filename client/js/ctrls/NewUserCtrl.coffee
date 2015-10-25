
define ['can', 'can/control', 'Auth', '_', '$'], (can, Control, Auth)->
  userInfo = new can.Map

  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/home/new-user.html', userInfo)
      # $('#winNewUser').window({width:600, height:400, modal:true, onClose:()=> this.destroy()})
      # $('#winNewUser').window('open');

      # $('.easyui-validatebox').validatebox()

      # $('#roles').combobox(
      #   required:true,
      #   multiple:true,
      #   valueField:'value',
      #   textField:'text'
      # )

      # $.getJSON(Auth.apiHost + 'mywms2/client/allRoles', {}
      #   , (data)->
      #     $('#roles').combobox(data: data)
      #   , (data)->
      #     $.messager.alert '错误', '获取角色信息失败！'
      #     $('#winNewUser').window('close');
      # )

      # $('#clientSelector').combogrid({
      #     panelWidth:500,
      #     delay: 300,
      #     # mode: 'remote',
      #     idField:'value',
      #     textField:'text',
      #     pagination : true,
      #     pageSize: 10,
      #     method: 'POST',
      #     url:"#{Auth.apiHost}mywms2/client/allByName",
      #     columns:[[
      #         {field:'value',title:'客户ID',width:80},
      #         {field:'text',title:'客户名',width:120}
      #     ]],
      #     keyHandler:
      #       query: (q, e)->
      #         $('#clientSelector').combogrid("grid").datagrid("reload", { 'username': q });
      #         $('#clientSelector').combogrid("setValue", q);
      # })
      ###############################
      ###############################

      $('#save').unbind 'click'
      $('#save').bind 'click', ()->
        if !$('#newUser').form('validate')
          $.messager.alert '提示', '请输入所有要求的内容！'
          return

        userInfo.attr('roleVoList': _.map($('#roles').combobox('getValues'), (it)->id:it))
        userInfo.attr('clientVo': {id:$('#clientSelector').combogrid('getValue')})
        console.log userInfo.attr()

        $.postJSON(Auth.apiHost + 'mywms2/user/create', userInfo.attr(),
          (data)->
            console.log data
            $('#winNewUser').window('close');
            $.messager.alert('提示', '新增用户成功！');
          (data)->
            console.log data
            $.messager.alert('提示', data, 'error');
        )
