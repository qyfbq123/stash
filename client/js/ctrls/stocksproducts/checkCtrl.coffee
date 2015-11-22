
define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'autocomplete'], (Ctrl, can, Auth, base)->
  return Ctrl.extend
    init: (el, data)->
      new base('', data) if !can.base
      this.element.html can.view('../../public/view/home/stocksproducts/check.html', {})

      datagrid = $('#checkGrid').datagrid({
        url: "#{Auth.apiHost}inventory/all/page"
        attr: "class": "table table-bordered table-striped"
        sorter: "bootstrap",
        pager: "bootstrap",
        noData: '无数据'
        paramsDefault: {paging:10}
        onComplete: ()->
        parse: (data)-> {total: data.total, data: data.rows}
        col:[{
            attrHeader: { "style": "width:150px;"},
            field: 'goodsVo'
            title: '商品名称'
            render: (data)-> data.value.name
          }, {
            attrHeader: { "style": "width:120px;"},
            field: 'goodsVo'
            title: '条形码'
            render: (data)-> data.value.barcode
          }, {
            attrHeader: { "style": "width:120px;"},
            field: 'goodsVo'
            title: 'SKU'
            render: (data)-> data.value.sku
          }, {
            attrHeader: { "style": "width:100px;"},
            field: 'quantity'
            title: '数量'
          }
        ]
      })
      $('#checkGrid').datagrid("filters", $('form'));
