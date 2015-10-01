
define ['can/control', 'can/view/mustache', 'Auth', 'newClientCtrl', '$'], (Ctrl, can, Auth, newClientCtrl)->
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

  getClient = (pageNum, pageSize)->
    $.getJSON(Auth.apiHost + 'mywms/client/page', {page: pageNum, rows: pageSize}
      , (data)->
        $('.easyui-pagination').pagination({total:data.total, pageSize:10})
        $('#clients').datagrid data:data
      , (data)->
        console.log 'error'
    )


  return Ctrl.extend
    init: ()->
      console.log this.element
      mergeData = []
      this.element.html can.view('../../public/view/home/client-management.html', {})

      $('#mainLayout').layout();
      $('#contentLayout').layout();
      $('.easyui-pagination').pagination({total:0, pageSize:10, onSelectPage: (pageNum, pageSize)->
        getClient pageNum, pageSize
        })

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

      getClient 0, 10

    '#addClientBtn click': ()->
      console.log 'click'
      new newClientCtrl('#dialog', {})
