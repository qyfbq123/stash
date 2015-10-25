
define ['can', 'can/control', 'homeCtrl', 'frameCtrl', 'Auth', 'localStorage', '_'], (can, Control, homeCtrl, frameCtrl, Auth, localStorage)->
  return Control.extend
    init: (el, data)->
      can.home = new homeCtrl('body', {}) if !can.home

      menus = localStorage.get('menus')
      it = _.find(menus, (item)-> item.url == data.id)
      new frameCtrl('#currentWork', it)

      can.base = @
