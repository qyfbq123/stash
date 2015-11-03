
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/report/exportReports.html', brandData)
