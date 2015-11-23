clickLocationUpdate = (location)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpLocationInfo', location
    window.location.hash = "#!home/location/locationAdd/#{location.id}"

clickDeleteLocation = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'location/delete', {locationId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )


define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'autocomplete'], (Ctrl, can, Auth, base)->
  locationData = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/location/locationView.html', locationData)

      cols = [{
          field: 'locked'
          title: '选择'
          render: (data)->
            "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
        },{
          field: 'name'
          title: '库位名称'
        }, {
          field: 'created'
          title: '创建时间'
          render: (data)-> new Date(data.value).toLocaleString()
        },{
          field: 'modfied'
          title: '最近修改'
          render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
        },{
          field:'usage'
          title:'已使用'
          render: (data)-> if data.value then '是' else '否'
        },{
          field: 'xcoord'
          title: '所在行'
        },{
          field: 'ycoord'
          title: '所在列'
        },{
          field: 'zcoord'
          title: '所在层'
        },{
          field: 'warehouseVo'
          title: '仓库信息'
          render: (data)->
            info =
              "<p>仓库名称&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
              "<p>仓库地址&nbsp;&nbsp;&nbsp;#{data?.value?.address}</p>" +
              "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactName}</p>" +
              "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.value?.contactTel}</p>" +
              "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.value?.contactEmail}</p>" +
              "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactQq}</p>" +
              "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.value?.contactFax}</p>" +
              "<p>联系Skype&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn}</p>"
            "<a href=\"javascript:jAlert('#{info}', '仓库信息');void(0);\">#{data?.value?.name}</a>"
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

      if Auth.user().companyVo.issystem
        cols.splice 1, 0, {
          field: ''
          title: '操作'
          render: (data)->
            "<a href='javascript:clickLocationUpdate(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
            "<a href='javascript:clickDeleteLocation(#{JSON.stringify(data.row)});void(0);' class='table-actions-button ic-table-delete'></a>"
        }

      datagrid = $('#locationList').datagrid({
        url: Auth.apiHost + 'location/page',
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        parse: (data)->
          return {total:data.total, data: data.rows}
        col: cols
      })

      $('#locationList').datagrid( "filters", $('#filterSelector'));

      $('#warehouseSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}location/warehouse/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)-> {value:it.name, data: it})
        onSelect: (suggestion)->
          $('#locationList').datagrid( "fetch", {warehouseId:suggestion.data.id, factor:$('#factor')[0].value, unused:!!$('#unusedSelector')[0].value});
      });
