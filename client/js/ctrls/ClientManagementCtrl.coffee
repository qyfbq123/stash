
define ['can/control', 'can/view/mustache', 'Auth', 'newClientCtrl', 'updateClientCtrl', '$'],
(Ctrl, can, Auth, newClientCtrl, updateClientCtrl)->
  PAGE_ZIE = 20
  currentPageOriginData = []
  currentPageMergeData = []
  isLoadFinish = false

  mergeCol = (merge, colName)->
    $('#clients').datagrid('mergeCells', {
      index: merge.index,
      field: colName,
      rowspan: merge.rowspan
    });

  onLoadSuccess = (data)->
    for i in [0...data.length] by 1
      merge = data[i];
      mergeCol(merge, 'locked');
      mergeCol(merge, 'name');
      mergeCol(merge, 'address');
      mergeCol(merge, 'desc');

  getClient = (pageNum, pageSize)->
    $.getJSON(Auth.apiHost + 'mywms/client/page', {page: pageNum, rows: pageSize}
      , (data)->
        $('.easyui-pagination').pagination({total:data.total, pageSize:PAGE_ZIE})
        $('#clients').datagrid data:data
      , (data)->
        console.log data
    )

  disabled = (ids)->
    $.postJSON(Auth.apiHost + 'mywms/client/disabled', {ids:ids}
      , (data)->
        console.log data
        $.messager.alert '提示', '请先选择一个需要更新的用户所在行！' if data.status != 0
      , (data)->
        $.messager.alert '错误', "http error: #{data.status}, #{data.statusText}"
      )

  return Ctrl.extend
    init: ()->
      isLoadFinish = false
      mergeData = []
      this.element.html can.view('../../public/view/home/client-management.html', {})

      $('#mainLayout').layout();
      $('#contentLayout').layout();
      $('.easyui-pagination').pagination({total:0, pageSize:PAGE_ZIE, onSelectPage: (pageNum, pageSize)->
        getClient pageNum, pageSize
        })

      $('#clients').datagrid 'onUncheck': (index, row) ->
        disabled row.id if isLoadFinish

      $('#clients').datagrid 'onCheck': (index, row) ->
        disabled row.id if isLoadFinish

      $('#clients').datagrid 'loadFilter': (ret) ->
        rets = []
        currentPageOriginData = ret.rows

        for i in [0...ret.rows.length] by 1
          clientInfo = ret.rows[i]
          merge = {}

          clientInfo.contacts ?= []
          if clientInfo.contacts.length == 0
            # clientInfo.locked = if clientInfo.locked == 0 then "启用" else "禁用"
            rets.push clientInfo
          else
            mergeData.push index:rets.length, rowspan:clientInfo.contacts.length
            for j in [0...clientInfo.contacts.length] by 1
              contractInfo = clientInfo.contacts[j]
              rets.push
                id: clientInfo.id
                # locked: if clientInfo.locked == 0 then "启用" else "禁用"
                locked: clientInfo.locked
                name: clientInfo.name,
                address: clientInfo.address,
                contacts_name: contractInfo.name,
                contacts_tel: contractInfo.tel,
                contacts_email: contractInfo.email,
                desc: clientInfo.desc

        currentPageMergeData = rets
        return total: rets.length, rows:rets

      $('#clients').datagrid 'onLoadSuccess':(data)->
        onLoadSuccess mergeData

        $('#clients').parent().find(".datagrid-header-check").children("input[type=checkbox]").eq(0).attr("style", "display:none")
        $('#clients').parent().find(".datagrid-header-check").eq(0).append("<span>启用/禁用</span>")

        $.each data.rows, (index, item)->
          if item.locked == 0
            $('#clients').datagrid('checkRow', index)

        isLoadFinish = true

      getClient 0, PAGE_ZIE

    '#addClientBtn click': ()->
      new newClientCtrl('#dialog', {})

    '#updateClientBtn click': ()->
      currentRow = $('#clients').datagrid('getSelected')
      originData = _.find(currentPageOriginData, (it)-> it.id == currentRow?.id)
      return $.messager.alert '提示', '请先选择一个需要更新的用户所在行！' if !originData

      new updateClientCtrl('#dialog', originData)
