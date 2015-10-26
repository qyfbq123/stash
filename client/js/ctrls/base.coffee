
define ['can', 'can/control', 'homeCtrl', 'frameCtrl', 'Auth', 'localStorage', '_'], (can, Control, homeCtrl, frameCtrl, Auth, localStorage)->
  return Control.extend
    init: (el, data)->
      menus = localStorage.get('menus')
      it = _.find(menus, (item)-> item.url == data.id)

      can.home = new homeCtrl('body', {}) if !can.home
      if !can.frame
        can.frame = new frameCtrl('#currentWork', it)
      else
        can.frame.update it

      can.base = @
