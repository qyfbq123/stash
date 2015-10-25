
define ['can/control', 'can/view/mustache', 'Auth', '_'], (Control, can, Auth, un)->
  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/home/dashboard.html', {})
