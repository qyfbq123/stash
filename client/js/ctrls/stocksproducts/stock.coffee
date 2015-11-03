
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/stock.html', brandData)

      // TODO
      # datagrid = $('#brandList').datagrid({
      #   url: Auth.apiHost + 'mywms2/goods/brand/page',
      #   attr: "class": "table table-bordered table-striped"
      #   sorter: "bootstrap",
      #   pager: "bootstrap",
      #   noData: '无数据'
      #   paramsDefault: {paging:10}
      #   parse: (data)->
      #     return {total:data.total, data: data.rows}
      #   col:[{
      #       field: 'locked'
      #       title: '选择'
      #       render: (data)->
      #         "<input style='width:50px;' type='checkbox' name='DataGridCheckbox' checked=#{data.value == 0 ? 'checked' : 'unchecked'}>"
      #     },{
      #       field: 'op'
      #       title: '操作'
      #       render: (data)->
      #         "<a href='javascript:clickBrandUpdate(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
      #         "<a href='javascript:clickDeleteBrand(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-delete'></a>"
      #     },{
      #       field: 'name'
      #       title: '商品名'
      #     },{
      #       field: 'created'
      #       title: '创建时间'
      #       render: (data)-> new Date(data.value).toLocaleString()
      #     },{
      #       field: 'modfied'
      #       title: '最近修改'
      #       render: (data)-> if data.value then new Date(data.value).toLocaleString() else '无'
      #     },{
      #       field: 'companyVo'
      #       title: '公司信息'
      #       render: (data)->
      #         info =
      #           "<p>公司名&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.name}</p>" +
      #           "<p>公司地址&nbsp;&nbsp;&nbsp;#{data?.value?.address}</p>" +
      #           "<p>联系人&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactName}</p>" +
      #           "<p>联系号码&nbsp;&nbsp;&nbsp;#{data?.value?.contactTel}</p>" +
      #           "<p>联系邮箱&nbsp;&nbsp;&nbsp;#{data?.value?.contactEmail}</p>" +
      #           "<p>联系QQ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#{data?.value?.contactQq}</p>" +
      #           "<p>联系传真&nbsp;&nbsp;&nbsp;#{data?.value?.contactFax}</p>" +
      #           "<p>联系MSN&nbsp;&nbsp;&nbsp;#{data?.value?.contactMsn}</p>"
      #         "<a href=\"javascript:jAlert('#{info}', '公司信息')\">#{data?.value?.name}</a>"
      #     }
      #   ]
      # })
