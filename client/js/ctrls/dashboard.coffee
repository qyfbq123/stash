
define ['can/control', 'can/view/mustache', 'base', 'Auth', '_', 'datagrid_plugin'], (Control, can, base, Auth, un)->
  pageData = new can.Map()

  return Control.extend
    init: (el, data)->
      this.element.html can.view('../public/view/home/dashboard.html', pageData)

      success = (data = {})->
        pageData.attr(data.data)

        $('#stockIn').datagrid({
          data: data?.data?.todayInVoList || []
          attr: "class": "table table-bordered table-striped"
          sorter: "bootstrap",
          pager: "bootstrap",
          noData: '无数据'
          paramsDefault: {paging:10}
          col:[{
              field: 'billnumber'
              title: '订单编号'
            }, {
              field: 'created'
              title: '创建时间'
              render: (data)-> new Date(data.value).toLocaleString()
            }, {
              field: 'date'
              title: '预计入库时间'
              render: (data)-> new Date(data.value).toLocaleString()
            }, {
              field: 'entries'
              title: '入库商品总数'
              render: (data)->
                total = 0
                _.each data.value, (it)-> total +=it.quantity
                total
            }, {
              field: 'creatorVo'
              title: '创建者'
              render: (data)-> data?.value?.username || ''
            }, {
              field: 'supplierVo'
              title: '供应商'
              render: (data)-> data?.value?.name || ''
            }, {
              field: 'desc'
              title: '订单描述'
            }
          ]
        })

        $('#stockOut').datagrid({
          data: data?.data?.todayOutVoList || []
          attr: "class": "table table-bordered table-striped"
          sorter: "bootstrap",
          pager: "bootstrap",
          noData: '无数据'
          paramsDefault: {paging:10}
          col:[{
              field: 'billnumber'
              title: '订单编号'
            }, {
              field: 'created'
              title: '创建时间'
              render: (data)-> new Date(data.value).toLocaleString()
            }, {
              field: 'date'
              title: '预计出库时间'
              render: (data)-> new Date(data.value).toLocaleString()
            }, {
              field: 'entries'
              title: '出库商品总数'
              render: (data)->
                total = 0
                _.each data.value, (it)-> total +=it.quantity
                total
            }, {
              field: 'creatorVo'
              title: '创建者'
              render: (data)-> data?.value?.username || ''
            }, {
              field: 'consigneeVo'
              title: '收货人'
              render: (data)-> data?.value?.username || ''
            }, {
              field: 'desc'
              title: '订单描述'
            }
          ]
        })
      failed = (data)->
        pageData.attr({})
      $.getJSON "#{Auth.apiHost}main/dashboard", {}, success, failed

