
define ['can/control', 'can/view/mustache', 'Auth', '_', 'localStorage', '$'], (Control, can, Auth, un, localStorage)->
  return Control.extend
    init: (el, data)->
      data.childMenu ?= []
      @wather = new can.Map(data)

      @update data

      # can.route.unbind "change"
      can.route.bind "change", (ev, attr, how, newVal, oldVal)=>
        newVal ?= ''
        suffix = newVal.split('/')
        suffix = suffix[suffix.length - 1]
        hit = _.find data.childMenu, (it)-> it.url == suffix
        childMenuName = if hit and hit.name then hit.name else '工作区域'
        @wather.attr('childMenuName', childMenuName)

    update: (data)->
      data.childMenu ?= []
      this.element.html can.view('../../public/view/home/frame.html', @wather)

      for menu in data.childMenu
        $('#menuList').append "<li><a href='#!home/#{data.url}/#{menu.url}'>#{menu.name}</a></li>"
