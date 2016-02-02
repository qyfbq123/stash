
define ['base', 'can', 'can/control', 'can/view/stache', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'fileInputZh', 'importComponent'], (base, can, Control, stache, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base
      this.element.html can.view('../../public/view/home/system/basicDataImport.html', brandData)

      $('#importComponents').append(can.stache("<DataImport subMenuId='#{data.subMenuId}'></DataImport>"))
