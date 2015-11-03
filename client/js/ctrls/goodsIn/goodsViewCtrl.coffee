clickDeleteGoodList = (company)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'mywms2/stock/in/delete', {userId:company.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can/view/mustache', 'Auth', 'base', 'datagrid_plugin'], (Ctrl, can, Auth, base)->
  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)

      this.element.html can.view('../../public/view/home/goodsIn/goodsView.html', {})

      datagrid = $('#goodsInList').datagrid({
        url: Auth.apiHost + 'mywms2/stock/in/page',
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
          }, {
            field: 'billnumber'
            title: '订单编号'
          }, {
            field: ''
            title: '操作'
            render: (data)->
              "<a href='javascript:clickDeleteGoodList(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'created'
            title: '创建时间'
            render: (data)-> new Date(data.value).toLocaleString()
          }, {
            field: 'date'
            title: '预计入库时间'
            render: (data)-> new Date(data.value).toLocaleString()
          }, {
            field: 'status'
            title: '状态'
            render: (data)->
              tagInfo = {}
              switch data.value
                when 'started' then tagInfo.class = 'bg-primary btn width100'; tagInfo.value = '等待确认'
                when 'confirmed' then tagInfo.class = 'bg-info btn width100'; tagInfo.value = '已经确认'
                when 'ended' then tagInfo.class = 'bg-success btn width100'; tagInfo.value = '已经完成'
              "<span class='#{tagInfo.class}'>#{tagInfo.value}</span>"
          },{
            field: 'desc'
            title: '公司描述'
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
          },{
            field: 'supplierVo'
            title: '供应商信息'
            render: (data)->
              info =
                "<p>供应商名称　#{data?.value?.name}</p>" +
                "<p>供应商地址　#{data?.value?.address}</p>" +
                "<p>联系人　　　#{data?.value?.contactName}</p>" +
                "<p>联系号码　　#{data?.value?.contactTel}</p>" +
                "<p>联系邮箱　　#{data?.value?.contactEmail}</p>" +
                "<p>联系QQ　　　#{data?.value?.contactQq}</p>" +
                "<p>联系传真　　#{data?.value?.contactFax}</p>" +
                "<p>联系MSN　　#{data?.value?.contactMsn}</p>"
              "<a href=\"javascript:jAlert('#{info}', '供应商信息')\">#{data?.value?.name}</a>"
          },{
            field: 'creatorVo'
            title: '创建者信息'
            render: (data)->
              roleNameList = _.pluck data.roleVoList, 'name'
              info =
                "<p>用户名　　　#{data?.value?.username}</p>" +
                "<p>用户别名　　#{data?.value?.cname}</p>" +
                "<p>用户地址　　#{data?.value?.address}</p>" +
                "<p>用户角色　　#{roleNameList}</p>" +
                "<p>所属公司　　#{data?.value?.companyVo?.name || '无'}</p>" +
                "<p>创建时间　　#{if data?.value?.created then new Date(data.value.created).toLocaleString() else '无'}</p>" +
                "<p>最新修改　　#{if data?.value?.modified then new Date(data.value.modified).toLocaleString() else '无'}</p>" +
                "<p>电话号码　　#{data?.value?.tel || ''}</p>"
              "<a href=\"javascript:jAlert('#{info}', '创建者信息')\">#{data?.value?.username}</a>"
          }
        ]
      })
