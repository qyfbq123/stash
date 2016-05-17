define ["can", "can/component","can/view/stache", 'Auth', 'localStorage', '_', 'jAlert', 'uploader'], (can, component, stache, Auth, localStorage)->
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
        pageData.attr('uploadUrl', 'basicdata/company')
      when 'warehouseDataImport'
        pageData.attr('title', '仓库')
        pageData.attr('downloadUrl', '仓库.xls')
        pageData.attr('uploadUrl', 'basicdata/warehouse')
      when 'locationDataImport'
        pageData.attr('title', '库位')
        pageData.attr('downloadUrl', '库位.xls')
        pageData.attr('uploadUrl', 'basicdata/location')
      when 'categoryDataImport'
        pageData.attr('title', '种类')
        pageData.attr('downloadUrl', '种类.xls')
        pageData.attr('uploadUrl', 'basicdata/category')
      when 'userDataImport'
        pageData.attr('title', '用户')
        pageData.attr('downloadUrl', '用户.xls')
        pageData.attr('uploadUrl', 'basicdata/user')
      when 'brandDataImport'
        pageData.attr('title', '品牌')
        pageData.attr('downloadUrl', '品牌.xls')
        pageData.attr('uploadUrl', 'basicdata/brand')
      when 'supplierDataImport'
        pageData.attr('title', '供应商')
        pageData.attr('downloadUrl', '供应商.xls')
        pageData.attr('uploadUrl', 'basicdata/supplier')
      when 'consigneeDataImport'
        pageData.attr('title', '收货人')
        pageData.attr('downloadUrl', '收货人.xls')
        pageData.attr('uploadUrl', 'basicdata/consignee')
      when 'goodsDataImport'
        pageData.attr('title', '商品')
        pageData.attr('downloadUrl', '商品.xls')
        pageData.attr('uploadUrl', 'basicdata/goods')
      when 'inventoryDataImport'
        pageData.attr('title', '库存')
        pageData.attr('downloadUrl', '库存.xls')
        pageData.attr('uploadUrl', 'basicdata/inventory')

  return can.Component.extend({
    tag: "DataImport",
    template: can.stache("
                         <div class='col-md-4'></div>
                         <div class='col-md-2'>
                         <input id='filePicker' type='file' class='file-loading'/>
                         </div>
                         <p>&nbsp;</p>
                         <div class='col-md-12'>
                           <a id='downloadUrl' href='./public/static/docs/{{downloadUrl}}' target='_blank' style='font-size:20px;' class='text-center pull-left'>{{title}}模板文件下载</a>
                           <div class='text-center pull-right'>
                            <input type='checkbox' can-value='isCover'></input>
                            <label id='isCover' class='text-danger'>是否覆盖已存在{{title}}</label>
                           </div>
                         </div>
                         "),
    viewModel: (attrs)->
      currentData = getImportInfo(attrs.submenuid)
      currentData
    events: {
      inserted:()->
        $('#isCover').hide() if(pageData.attr('title') == '库存')
        $('#filePicker').uploadify({
          'width': 200
          'fileSizeLimit': '1024k'
          'buttonText': "选择【#{pageData.attr('title')}】表格文件上传"
          'fileTypeDesc' : '表格文件',
          'fileTypeExts' : '*.xls; *.xlsx',
          'swf': './lib/uploadify/uploadify.swf',
          'uploader': "#{Auth.apiHost}#{pageData.attr('uploadUrl')};jsessionid=#{localStorage.get 'sessionId'}",
          'formData': (isCover: pageData.attr('isCover'))
          'onUploadStart' : (file)->
            $("#filePicker").uploadify "settings", "formData", (isCover: pageData.attr('isCover') )
          'onUploadSuccess': (file, data, response)->
            data = JSON.parse data
            if(data.status != 0)
              jAlert "#{data.message}", "错误"
            else jAlert "#{pageData.attr('title')}导入成功！", "成功"
          'onUploadError': (file, errorCode, errorMsg, errorString)->
            jAlert "#{errorString}，请下载模板文件查看格式！", "错误"
        });

        # $("#filePicker").fileinput({
        #   dropZoneTitle: "上传#{pageData.attr('title')}表格文件"
        #   language: 'zh'
        #   maxFileCount: 10
        #   minImageWidth: 10
        #   minImageHeight: 10
        #   uploadUrl: "#{Auth.apiHost}#{pageData.attr('uploadUrl')}"
        #   uploadExtraData: ()->
        #     isCover: pageData.attr('isCover')
        #   allowedFileExtensions: ["xls", "xlsx"]
        #   slugCallback: (name)-> name
        # });

        # done = (e, data)->
        #   if data.response.status != 0
        #     jAlert "#{data.response.message}，请下载模板文件查看格式！", "错误"
        #   else
        #     jAlert "#{pageData.attr('title')}导入成功！", "成功"
        #   $('#filePicker').fileinput('clear');
        #   $('#filePicker').fileinput('enable');

        # $("#filePicker").on('fileuploaderror', done)
        # $("#filePicker").on('filebatchuploaderror', done)
        # $("#filePicker").on('fileuploaded', done)
    }
  });
