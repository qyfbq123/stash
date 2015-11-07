define ["can", "can/component","can/view/stache", 'Auth', 'localStorage', '_', 'jAlert'], (can, component, stache, Auth, localStorage)->
  pageData = new can.Map({
    title: ''
    downloadUrl: ''
    uploadUrl: ''
    isCover: false
  })

  getImportInfo = (submenuid)->
    switch submenuid
      when 'companyDataImport'
        pageData.attr('title', '公司')
        pageData.attr('downloadUrl', '公司.xls')
        pageData.attr('uploadUrl', '/basicdata/company')
      when 'warehouseDataImport'
        pageData.attr('title', '仓库')
        pageData.attr('downloadUrl', '仓库.xls')
        pageData.attr('uploadUrl', '/basicdata/warehouse')
      when 'locationDataImport'
        pageData.attr('title', '库位')
        pageData.attr('downloadUrl', '库位.xls')
        pageData.attr('uploadUrl', '/basicdata/location')
      when 'categoryDataImport'
        pageData.attr('title', '种类')
        pageData.attr('downloadUrl', '种类.xlsx')
        pageData.attr('uploadUrl', '/basicdata/category')
      when 'userDataImport'
        pageData.attr('title', '用户')
        pageData.attr('downloadUrl', '用户.xls')
        pageData.attr('uploadUrl', '/basicdata/user')
      when 'brandDataImport'
        pageData.attr('title', '品牌')
        pageData.attr('downloadUrl', '品牌.xls')
        pageData.attr('uploadUrl', '/basicdata/brand')
      when 'supplierDataImport'
        pageData.attr('title', '供应商')
        pageData.attr('downloadUrl', '供应商.xlsx')
        pageData.attr('uploadUrl', '/basicdata/supplier')
      when 'consigneeDataImport'
        pageData.attr('title', '收货人')
        pageData.attr('downloadUrl', '收货人.xlsx')
        pageData.attr('uploadUrl', '/basicdata/consignee')
      when 'goodsDataImport'
        pageData.attr('title', '商品')
        pageData.attr('downloadUrl', '商品.xls')
        pageData.attr('uploadUrl', '/basicdata/goods')

  return can.Component.extend({
    tag: "DataImport",
    template: can.stache("
                         <input id='filePicker' type='file' class='file-loading'/>
                         <p>&nbsp;</p>
                         <div class='col-md-12'>
                           <a id='downloadUrl' href='./public/static/docs/{{downloadUrl}}' target='_blank' style='font-size:20px;' class='text-center pull-left'>{{title}}模板文件下载</a>
                           <div class='text-center pull-right'>
                            <input type='checkbox' can-value='isCover'></input>
                            <label class='text-danger'>是否覆盖已存在{{title}}</label>
                           </div>
                         </div>
                         "),
    viewModel: (attrs)->
      currentData = getImportInfo(attrs.submenuid)
      currentData
    events: {
      inserted:()->
        $("#filePicker").fileinput({
          dropZoneTitle: "上传#{pageData.attr('title')}表格文件"
          language: 'zh'
          maxFileCount: 10
          minImageWidth: 10
          minImageHeight: 10
          uploadUrl: "#{Auth.apiHost}mywms2#{pageData.attr('uploadUrl')}"
          uploadExtraData: ()->
            isCover: pageData.attr('isCover')
          allowedFileExtensions: ["xls", "xlsx"]
          slugCallback: (name)-> name
        });

        done = (e, data)->
          if data.response.status != 0
            jAlert "#{data.response.message}，请下载模板文件查看格式！", "错误"
          else
            jAlert "#{pageData.attr('title')}导入成功！", "成功"

        $("#filePicker").on('fileuploaderror', done)
        $("#filePicker").on('filebatchuploaderror', done)
        $("#filePicker").on('fileuploaded', done)
    }
  });
