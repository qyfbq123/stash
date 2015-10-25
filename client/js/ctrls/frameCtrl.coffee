
define ['can/control', 'can/view/mustache', 'Auth', '_', 'localStorage', '$'], (Control, can, Auth, un, localStorage)->
  return Control.extend
    init: (el, data)->
      data.childMenu ?= []
      this.element.html can.view('../../public/view/home/frame.html', data)

      for menu in data.childMenu
        $('#menuList').append "<li><a href='#!home/#{data.url}/#{menu.url}'>#{menu.name}</a></li>"

