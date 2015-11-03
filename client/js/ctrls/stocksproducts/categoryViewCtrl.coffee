clickCategoryUpdate = (data)->
  require ['localStorage'], (localStorage)->
    localStorage.set 'tmpCategoryInfo', data
    window.location.hash = "#!home/stocksproducts/categoryAdd/#{data.id}"

clickDeleteCategory = (data)->
  require ['Auth', '$', 'jAlert'], (Auth)->
    jConfirm '确认删除？', '警告', (delete_)->
      return if !delete_

      $.getJSON(Auth.apiHost + 'mywms2/goods/category/delete', {categoryId:data.id}
        ,(data)->
          if data.status == 0
            jAlert '删除成功！', '提示'
          else
            jAlert data.message, '失败'
        ,(data)->
          jAlert data.responseText, "错误"
        )

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert'], (Ctrl, can, Auth, base)->
  categoryList = new can.Map

  return Ctrl.extend
    init: (el, data)->
      if !can.base
        new base('', data)
      this.element.html can.view('../../public/view/home/stocksproducts/categoryView.html', categoryList)

      datagrid = $('#categoryList').datagrid({
        url: Auth.apiHost + 'mywms2/goods/category/page',
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
          },{
            field: 'op'
            title: '操作'
            render: (data)->
              "<a href='javascript:clickCategoryUpdate(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-edit'></a>&nbsp;&nbsp;&nbsp;&nbsp;" +
              "<a href='javascript:clickDeleteCategory(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-delete'></a>"
          },{
            field: 'name'
            title: '商品名'
          },{
            field: 'desc'
            title: '描述'
          },{
            field: 'pid'
            title: 'pid'
          }
        ]
      })
