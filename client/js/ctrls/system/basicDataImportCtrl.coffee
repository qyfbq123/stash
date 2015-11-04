
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'fileInputZh'], (base, can, Control, Auth, localStorage)->
  brandData = new can.Map()

  return Control.extend
    init: (el, data)->
      new base('', data) if !can.base

      this.element.html can.view('../../public/view/home/system/basicDataImport.html', brandData)

      $("#filePicker").fileinput({
        dropZoneTitle: '上传公司表格文件'
        language: 'zh'
        maxFileCount: 10
        minImageWidth: 10
        minImageHeight: 10
        uploadUrl: "#{Auth.apiHost}mywms2/basicdata/company"
        allowedFileExtensions: ["xls", "xlsx"]
        slugCallback: (name)-> name
      });

      done = (e, data)->
        if data.response.status != 0
          jAlert "#{data.response.message}，请下载模板文件查看格式！", "错误"
        else
          jAlert "公司信息导入成功！", "成功"

      $("#filePicker").on('fileuploaderror', done)
      $("#filePicker").on('filebatchuploaderror', done)
      $("#filePicker").on('fileuploaded', done)
