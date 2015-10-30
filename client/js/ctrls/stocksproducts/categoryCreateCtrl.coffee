
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  categoryData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/stocksproducts/categoryCreate.html', categoryData)

      isNew = window.location.hash.endsWith('categoryAdd')
      if isNew
        for k, v of categoryData.attr()
          categoryData.removeAttr(k)
        localStorage.rm 'tmpCategoryInfo'
      else
        tmpCategoryInfo = localStorage.get 'tmpCategoryInfo'
        categoryData.attr(tmpCategoryInfo)

      $('#createCategory').unbind 'click'
      $('#createCategory').bind 'click', ()->
        return if !$('#categoryCreate').valid()

        url = Auth.apiHost + if isNew then 'mywms2/goods/category/create' else 'mywms2/goods/category/update'
        $.postJSON(url, categoryData.attr(),
          (data)->
            for k, v of categoryData.attr()
              categoryData.removeAttr(k)

            if data.status == 0
              if isNew then jAlert "新增种类成功！", "提示" else jAlert "更新种类成功！", "提示"
            else
              jAlert "#{data.message}", "提示"
          (data)->
            jAlert "错误", data.responseText
        )
