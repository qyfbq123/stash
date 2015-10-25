
define ['can', 'can/control', 'Auth', '_'], (can, Control, Auth)->

  contacts = []
  for i in [0...5] by 1
    contacts.push
      name: ''
      tel: ''
      email: ''

  userInfo = new can.Map
    name: ''
    address: ''
    desc: ''
    contact1: contacts[0]
    contact2: contacts[1]
    contact3: contacts[2]
    contact4: contacts[3]
    contact5: contacts[4]

  return Control.extend
    init: (el, data)->
      this.element.html can.view('../../public/view/home/new-client.html', userInfo)
      $('#winNewClient').window({width:600, height:400, modal:true, onClose:()=>
        this.destroy()
        })
      $('#winNewClient').window('open');

      $('.easyui-validatebox').validatebox()

      $('#save').unbind 'click'
      $('#save').bind 'click', ()->
        if !$('#newClient').form('validate')
          $.messager.alert '提示', '请输入所有要求的内容！'
          return

        user = {}
        _.map(userInfo.attr(), (it, key)->
          if key.indexOf('contact') == 0
            user.contacts ?= []
            user.contacts.push it if it.name && it.tel && it.email
          else
            user[key] = it
        )

        console.log user
        $.postJSON(Auth.apiHost + 'mywms2/client/create', user,
          (data)->
            $('#winNewClient').window('close');
            $.messager.alert('新增客户成功', '新增客户成功！');
          (data)->
            $.messager.alert('新增客户失败', data, 'error');
        )
