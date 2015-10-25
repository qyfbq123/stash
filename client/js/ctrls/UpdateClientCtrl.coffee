
define ['can', 'can/control', 'Auth', '_'], (can, Control, Auth)->
  userInfo = new can.Map {}

  genData = (data)->
    id: data.id
    name: data.name
    address: data.address
    desc: data.desc
    contact1: data.contacts[0]?={}
    contact2: data.contacts[1]?={}
    contact3: data.contacts[2]?={}
    contact4: data.contacts[3]?={}
    contact5: data.contacts[4]?={}

  return Control.extend
    init: (el, data)->
      userInfo.attr genData(data)
      console.log userInfo.attr()
      this.element.html can.view('../../public/view/home/update-client.html', userInfo)

      $('#winUpdateClient').window({width:600, height:400, modal:true})
      $('#winUpdateClient').window('open');
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
            user.contacts.push it if (it.name && it.tel) || (it.name && it.email)
          else
            user[key] = it
        )

        $.postJSON(Auth.apiHost + 'mywms2/client/update', user,
          (data)->
            if data.status != 0
              return $.messager.alert('提示', "更新客户信息失败-#{data.message}");

            $('#winUpdateClient').window('close');
            $.messager.alert('提示', '更新客户信息成功！');
          (data)->
            $.messager.alert('提示', "http error: #{data.status}, #{data.statusText}", 'error');
        )
