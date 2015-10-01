
define ['can/control', 'can/view/mustache', 'Auth', '$'], (Ctrl, can, Auth)->
  mergeCol = (merge, colName)->
    $('#clients').datagrid('mergeCells', {
      index: merge.index,
      field: colName,
      rowspan: merge.rowspan
    });

  onLoadSuccess = (data)->
    for i in [0...data.length] by 1
      merge = data[i];
      mergeCol(merge, 'name');
      mergeCol(merge, 'address');
      mergeCol(merge, 'desc');

  return Ctrl.extend
    init: ()->
      console.log this.element
      mergeData = []
      this.element.html can.view('../../public/view/home/client-management.html', {})

      $('#mainLayout').layout();
      $('#contentLayout').layout();
      $('createClientDlg').dialog();

      $('#clients').datagrid 'loadFilter': (ret) ->
        rets = []
        console.log ret

        for i in [0...ret.rows.length] by 1
          clientInfo = ret.rows[i]
          merge = {}

          clientInfo.contacts ?= []
          if clientInfo.contacts.length == 0
            rets.push clientInfo
          else
            mergeData.push index:i, rowspan:clientInfo.contacts.length
            for j in [0...clientInfo.contacts.length] by 1
              contractInfo = clientInfo.contacts[j]
              rets.push
                name: clientInfo.name,
                address: clientInfo.address,
                contacts_name: contractInfo.name,
                contacts_tel: contractInfo.tel,
                contacts_email: contractInfo.email,
                desc: clientInfo.desc
        return total: rets.length, rows:rets

      $('#clients').datagrid 'onLoadSuccess':(data)->
        onLoadSuccess mergeData

      $.get(Auth.apiHost + 'mywms/client/page', (data)->
        console.log data
        $('#clients').datagrid data:data
      ).fail (data)->

    '#addClientBtn click': ()->
      console.log 'click'
    # '.easyui-datagrid onLoadSuccess', ()->
    #   console.log 'onLoadSuccess'

