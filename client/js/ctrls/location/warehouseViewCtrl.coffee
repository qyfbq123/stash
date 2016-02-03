clickWarehouseUpdate = (location)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpWarehouseInfo', location
    window.location.hash = "#!home/location/warehouseAdd/#{location.id}"

clickDeleteWarehouse = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'warehouse/delete', {warehouseId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )


define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  warehouseData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/location/warehouseView.html', warehouseData)

      datagrid = $('#warehouseList').datagrid({
        url: Auth.apiHost + 'location/warehouse/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        parse: (data)->
          return {total:data.total, data: data.rows}
        col:[
          # {
          #   field: 'locked'
          #   title: '选择'
          #   render: (data)->
          #     "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
          # },
          {
            attrHeader: { "style": "width:67px;"}
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:clickWarehouseUpdate(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='javascript:clickDeleteWarehouse(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'name'
            title: '仓库名称'
          }, {
            field: 'address'
            title: '仓库地址'
          },{
            field: 'desc'
            title: '仓库描述'
          },{
            field:'contactName'
            title:'联系人'
            render: (data)->
              info =
                "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.row?.contactName ||''}</p>" +
                "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.row?.contactTel || ''}</p>" +
                "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.row?.contactEmail || ''}</p>" +
                "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.row?.contactQq || ''}</p>" +
                "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.row?.contactFax || ''}</p>" +
                "<p>联系Skype&nbsp;&nbsp;&nbsp;#{data?.row?.contactMsn || ''}</p>" +
                "<p>联系人描述&nbsp;&nbsp;&nbsp;#{data?.row?.contactDesc || ''}</p>"
              "<a href=\"javascript:jAlert('#{info}', '联系人信息');void(0);\">#{data.value}</a>"
        }]
      })

      # $('#warehouseList').datagrid( "filters", $('#filterSelector'));
      $('#select').bind 'click', ()->
        $('#warehouseList').datagrid 'fetch', $('#filterSelector').serializeObject()
