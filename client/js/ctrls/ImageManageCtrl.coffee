deleteImages = (image)->
  require ['Auth', 'jAlert'], (Auth)->
    success = (data)->
      jAlert '删除图片成功！', '提示'
    failed = (data)->
      jAlert '删除图片失败！', '警告'

    image.path = image.path.substring(image.path.indexOf('=') + 1)
    $.postJSON "#{Auth.apiHost}goods/photo/delete", [image], success, failed

define ['can/control', 'can', 'Auth', 'base', 'datagrid_plugin', 'jAlert', 'imageView', 'fileInputZh'], (Ctrl, can, Auth, base)->
  return Ctrl.extend
    init: (el, data)->
      this.element.html can.view('../../public/view/home/ImageManager.html', {})

      $("#uploadImg").fileinput({
        language: 'zh'
        maxFileCount: 10
        minImageWidth: 10
        minImageHeight: 10
        uploadUrl: "#{Auth.apiHost}goods/photo/upload?goodsId=#{data.id}"
        allowedFileExtensions: ["jpg", "png", "gif"]
        slugCallback: (name)-> name
      });

      $('#filePicker').on 'filebatchuploadsuccess', ()->
        dataData.attr({})
        jAlert '图片上传成功！', '提示'

      $('#filePicker').on 'filebatchuploaderror', ()->
        jAlert '图片上传失败！', '提示'

      datagrid = $('#imageList').datagrid({
        data: data.imgs
        attr: "class": "table table-bordered table-striped"
        pager: "bootstrap",
        noData: '无数据'
        sorter: "bootstrap"
        paramsDefault: {paging:10}
        col:[{
            field: 'path'
            title: '路径'
            render: (data)-> "<a href=#{data.value}><img class='imgView' src=#{data.value}></img></a>"
          },{
            field: 'uploadDate'
            title: '上传日期'
            render: (data)-> new Date(data.value).toLocaleString()
          },{
            field: ''
            title: '删除'
            render: (data)-> "<a href='javascript:deleteImages(#{JSON.stringify(data.row)})' class='table-actions-button ic-table-delete'></a>"
          }
        ]
      })

      $('#backToStockView').unbind 'click'
      $('#backToStockView').bind 'click', ()=>
        $('#imageManager').empty()
        $('#stockItemList').attr('style', 'display:block;')
