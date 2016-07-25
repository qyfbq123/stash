require.config
  baseUrl: './lib'
  paths:
    _: 'underscore/underscore-min'
    $: 'jquery/dist/jquery.min'
    can: 'CanJS/amd/can'
    loading: 'jquery-loading/dist/jquery.loading.min'
    datagrid_plugin: 'jquery.datagrid/plugins/jquery.datagrid.bootstrap3'
    datagrid: 'jquery.datagrid/jquery.datagrid'
    autocomplete: 'devbridge-autocomplete/dist/jquery.autocomplete.min'
    tokenize: 'jquery-tokenize/jquery.tokenize'
    validate: 'jquery-validation/dist/jquery.validate.min'
    uploader: 'uploadify/jquery.uploadify.min'
    fileInput: 'bootstrap-fileinput/js/fileinput.min'
    fileInputZh: 'bootstrap-fileinput/js/fileinput_locale_zh'
    imageView: 'magnific-popup/dist/jquery.magnific-popup.min'
    dateTimePicker: 'datetimepicker/jquery.datetimepicker'
    printer: 'jQuery.print/jQuery.print'
    lscache: 'lscache/lscache.min'

    jqueryEx: '../public/js/servs/jQueryExtend'
    jAlert: '../public/js/plugins/jquery.alerts'
    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'

    base: '../public/js/ctrls/base'
    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'
    imageManageCtrl: '../public/js/ctrls/ImageManageCtrl'

    dashboardCtrl: '../public/js/ctrls/dashboard'
    jqueryResizableColumns: 'jquery-resizable-columns/dist/jquery.resizableColumns.min'
    storeJs: 'store-js/store.min'

    # 公司下的控制器
    companyNewCtrl: '../public/js/ctrls/company/companyNewCtrl'
    companyViewCtrl: '../public/js/ctrls/company/companyViewCtrl'
    userNewCtrl: '../public/js/ctrls/company/userNewCtrl'
    userViewCtrl: '../public/js/ctrls/company/userViewCtrl'

    # 库存 & 商品
    stockViewCtrl: '../public/js/ctrls/stocksproducts/stock'
    stockUpdateCtrl: '../public/js/ctrls/stocksproducts/stockUpdateCtrl'
    brandViewCtrl: '../public/js/ctrls/stocksproducts/brandViewCtrl'
    brandCreateCtrl: '../public/js/ctrls/stocksproducts/brandCreateCtrl'
    categoryViewCtrl: '../public/js/ctrls/stocksproducts/categoryViewCtrl'
    categoryCreateCtrl: '../public/js/ctrls/stocksproducts/categoryCreateCtrl'
    supplierViewCtrl:  '../public/js/ctrls/stocksproducts/supplierViewCtrl'
    supplierNewCtrl:  '../public/js/ctrls/stocksproducts/supplierNewCtrl'
    consigneeViewCtrl:  '../public/js/ctrls/stocksproducts/consigneeViewCtrl'
    consigneeCreateCtrl:  '../public/js/ctrls/stocksproducts/consigneeCreateCtrl'
    stockItemCreateCtrl:  '../public/js/ctrls/stocksproducts/stockItemCreateCtrl'
    stockItemViewCtrl:  '../public/js/ctrls/stocksproducts/stockItemViewCtrl'
    migrateCtrl:  '../public/js/ctrls/stocksproducts/migrateCtrl'
    checkCtrl:  '../public/js/ctrls/stocksproducts/checkCtrl'

    # 仓库 & 库位
    warehouseAddCtrl:  '../public/js/ctrls/location/warehouseAddCtrl'
    warehouseViewCtrl:  '../public/js/ctrls/location/warehouseViewCtrl'
    locationAddCtrl:  '../public/js/ctrls/location/locationAddCtrl'
    locationViewCtrl:  '../public/js/ctrls/location/locationViewCtrl'

    # 进货
    goodsInViewCtrl: '../public/js/ctrls/goodsIn/goodsViewCtrl'
    goodsInCreateCtrl: '../public/js/ctrls/goodsIn/goodsCreateCtrl'

    # 出货
    goodsOutViewCtrl: '../public/js/ctrls/goodsOut/goodsViewCtrl'
    goodsOutCreateCtrl: '../public/js/ctrls/goodsOut/goodsCreateCtrl'

    # 系统
    basicDataImportCtrl: '../public/js/ctrls/system/basicDataImportCtrl'
    importComponent: '../public/js/ctrls/system/importComponent'

    # 报告
    exportReportsCtrl: '../public/js/ctrls/report/exportReportsCtrl'


  shim:
    can: ['$', 'jqueryEx']
    uploader: ['$']
    loading: ['$']
    jqueryEx: ['$']
    datagrid: ['$']
    jAlert: ['$']
    datagrid_plugin: ['datagrid']
    autocomplete: ['$']
    validate: ['$']
    fileInputZh: ['fileInput', '$']
    dateTimePicker: ['$']
    jqueryResizableColumns: ['$']

require ['can', 'Auth', 'localStorage'], (can, Auth, localStorage)->
  $.ajaxSetup cache:false

  validRoute = (route, p)->
    if !Auth.logined() && route != 'login'
      window.location.hash = '!login'
      delete can.home
    else if !route
      window.location.hash = '!home'

  Router = can.Control({
    '{can.route} change': (ev, attr, how, newVal, oldVal)->
      validRoute ev.route, 'change'
      Auth.refresh()
      return false

    'login route': (data)->
      require ['loginCtrl'], (loginCtrl)->
        new loginCtrl('body', {})
    'logout route': (data)->
      Auth.logout()
      delete can.home
    'route': ()->
      window.location.hash = '!login'
    'home route': (data)->
      return if !Auth.logined()
      require ['base'], (base)->
        new base('', {id:'dashboard'})
    'home/:id route': (data)->
      return if !Auth.logined()
      require ['base'], (base)->
        new base('', data)

    'home/dashboard/dashboardView route': (data)->
      return if !Auth.logined()
      require ['dashboardCtrl', 'base'], (dashboardCtrl, base)->
        new base('', data) if !can.base
        new dashboardCtrl('#rightWorkspace', {id:'dashboard'})

    'home/company/companyAdd route': (data)->
      return if !Auth.logined()
      require ['companyNewCtrl', 'base'], (companyNewCtrl, base)->
        new base('', data) if !can.base
        new companyNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/companyAdd/:id route': (data)->
      return if !Auth.logined()
      require ['companyNewCtrl', 'base'], (companyNewCtrl, base)->
        new base('', data) if !can.base
        new companyNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/companyView route': (data)->
      return if !Auth.logined()
      require ['companyViewCtrl', 'base'], (companyViewCtrl, base)->
        new base('', data) if !can.base
        new companyViewCtrl('#rightWorkspace', {id:'company'})

    'home/company/userAdd route': (data)->
      return if !Auth.logined()
      require ['userNewCtrl', 'base'], (userNewCtrl, base)->
        new base('', data) if !can.base
        new userNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/userAdd/:id route': (data)->
      return if !Auth.logined()
      require ['userNewCtrl', 'base'], (userNewCtrl, base)->
        new base('', data) if !can.base
        new userNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/userView route': (data)->
      return if !Auth.logined()
      require ['userViewCtrl', 'base'], (userViewCtrl, base)->
        new base('', data) if !can.base
        new userViewCtrl('#rightWorkspace', {id:'company'})

    'home/goodsOut/goodsOutAdd route': (data)->
      return if !Auth.logined()
      require ['goodsOutCreateCtrl', 'base'], (goodsOutCreateCtrl, base)->
        new base('', data) if !can.base
        new goodsOutCreateCtrl('#rightWorkspace', {id:'goodsOut'})
    'home/goodsOut/goodsOutAdd/:id route': (data)->
      return if !Auth.logined()
      require ['goodsOutCreateCtrl', 'base'], (goodsOutCreateCtrl, base)->
        new base('', data) if !can.base
        new goodsOutCreateCtrl('#rightWorkspace', {id:'goodsOut'})
    'home/goodsOut/goodsOutView route': (data)->
      return if !Auth.logined()
      require ['goodsOutViewCtrl', 'base'], (goodsOutViewCtrl, base)->
        new base('', data) if !can.base
        new goodsOutViewCtrl('#rightWorkspace', {id:'goodsOut'})

    'home/goodsIn/goodsInAdd route': (data)->
      return if !Auth.logined()
      require ['goodsInCreateCtrl', 'base'], (goodsInCreateCtrl, base)->
        new base('', data) if !can.base
        new goodsInCreateCtrl('#rightWorkspace', {id:'goodsIn'})
    'home/goodsIn/goodsInAdd/:id route': (data)->
      return if !Auth.logined()
      require ['goodsInViewCtrl', 'base'], (goodsInViewCtrl, base)->
        new base('', data) if !can.base
        new goodsInViewCtrl('#rightWorkspace', {id:'goodsIn'})
    'home/goodsIn/goodsInView route': (data)->
      return if !Auth.logined()
      require ['goodsInViewCtrl', 'base'], (goodsInViewCtrl, base)->
        new base('', data) if !can.base
        new goodsInViewCtrl('#rightWorkspace', {id:'goodsIn'})

    'home/stocksproducts/stock route': (data)->
      return if !Auth.logined()
      require ['stockViewCtrl', 'base'], (stockViewCtrl, base)->
        new base('', data) if !can.base
        new stockViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/stock/:id route': (data)->
      return if !Auth.logined()
      require ['stockUpdateCtrl', 'base'], (stockUpdateCtrl, base)->
        new base('', data) if !can.base
        new stockUpdateCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/stockItemAdd route': (data)->
      return if !Auth.logined()
      require ['stockItemCreateCtrl', 'base'], (stockItemCreateCtrl, base)->
        new base('', data) if !can.base
        new stockItemCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/stockItemAdd/:id route': (data)->
      return if !Auth.logined()
      require ['stockItemCreateCtrl', 'base'], (stockItemCreateCtrl, base)->
        new base('', data) if !can.base
        new stockItemCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/stockItemView route': (data)->
      return if !Auth.logined()
      require ['stockItemViewCtrl', 'base'], (stockItemViewCtrl, base)->
        new base('', data) if !can.base
        new stockItemViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/brandAdd route': (data)->
      return if !Auth.logined()
      require ['brandCreateCtrl', 'base'], (brandCreateCtrl, base)->
        new base('', data) if !can.base
        new brandCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/brandAdd/:id route': (data)->
      return if !Auth.logined()
      require ['brandCreateCtrl', 'base'], (brandCreateCtrl, base)->
        new base('', data) if !can.base
        new brandCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/brandView route': (data)->
      return if !Auth.logined()
      require ['brandViewCtrl', 'base'], (brandViewCtrl, base)->
        new base('', data) if !can.base
        new brandViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/categoryAdd route': (data)->
      return if !Auth.logined()
      require ['categoryCreateCtrl', 'base'], (categoryCreateCtrl, base)->
        new base('', data) if !can.base
        new categoryCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/categoryAdd/:id route': (data)->
      return if !Auth.logined()
      require ['categoryCreateCtrl', 'base'], (categoryCreateCtrl, base)->
        new base('', data) if !can.base
        new categoryCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/categoryView route': (data)->
      return if !Auth.logined()
      require ['categoryViewCtrl', 'base'], (categoryViewCtrl, base)->
        new base('', data) if !can.base
        new categoryViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/supplierAdd route': (data)->
      return if !Auth.logined()
      require ['supplierNewCtrl', 'base'], (supplierNewCtrl, base)->
        new base('', data) if !can.base
        new supplierNewCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/supplierAdd/:id route': (data)->
      return if !Auth.logined()
      require ['supplierNewCtrl', 'base'], (supplierNewCtrl, base)->
        new base('', data) if !can.base
        new supplierNewCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/supplierView route': (data)->
      return if !Auth.logined()
      require ['supplierViewCtrl', 'base'], (supplierViewCtrl, base)->
        new base('', data) if !can.base
        new supplierViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/consigneeAdd route': (data)->
      return if !Auth.logined()
      require ['consigneeCreateCtrl', 'base'], (consigneeCreateCtrl, base)->
        new base('', data) if !can.base
        new consigneeCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/consigneeAdd/:id route': (data)->
      return if !Auth.logined()
      require ['consigneeCreateCtrl', 'base'], (consigneeCreateCtrl, base)->
        new base('', data) if !can.base
        new consigneeCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/consigneeView route': (data)->
      return if !Auth.logined()
      require ['consigneeViewCtrl', 'base'], (consigneeViewCtrl, base)->
        new base('', data) if !can.base
        new consigneeViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/inventoryMigrate route': (data)->
      return if !Auth.logined()
      require ['migrateCtrl', 'base'], (migrateCtrl, base)->
        new base('', data) if !can.base
        new migrateCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/inventoryCheck route': (data)->
      return if !Auth.logined()
      require ['checkCtrl', 'base'], (checkCtrl, base)->
        new base('', data) if !can.base
        new checkCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/location/warehouseAdd route': (data)->
      return if !Auth.logined()
      require ['warehouseAddCtrl', 'base'], (warehouseAddCtrl, base)->
        new base('', data) if !can.base
        new warehouseAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/warehouseAdd/:id route': (data)->
      return if !Auth.logined()
      require ['warehouseAddCtrl', 'base'], (warehouseAddCtrl, base)->
        new base('', data) if !can.base
        new warehouseAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/warehouseView route': (data)->
      return if !Auth.logined()
      require ['warehouseViewCtrl', 'base'], (warehouseViewCtrl, base)->
        new base('', data) if !can.base
        new warehouseViewCtrl('#rightWorkspace', {id:'location'})

    'home/location/locationAdd route': (data)->
      return if !Auth.logined()
      require ['locationAddCtrl', 'base'], (locationAddCtrl, base)->
        new base('', data) if !can.base
        new locationAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/locationAdd/:id route': (data)->
      return if !Auth.logined()
      require ['locationAddCtrl', 'base'], (locationAddCtrl, base)->
        new base('', data) if !can.base
        new locationAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/locationView route': (data)->
      return if !Auth.logined()
      require ['locationViewCtrl', 'base'], (locationViewCtrl, base)->
        new base('', data) if !can.base
        new locationViewCtrl('#rightWorkspace', {id:'location'})

    'home/report/:id route': (data)->
      return if !Auth.logined()
      require ['exportReportsCtrl', 'base'], (exportReportsCtrl, base)->
        new base('', data) if !can.base
        new exportReportsCtrl('#rightWorkspace', {id:'report', subMenuId: data.id})

    'home/system/:id route': (data)->
      return if !Auth.logined()
      require ['basicDataImportCtrl', 'base'], (basicDataImportCtrl, base)->
        new base('', data) if !can.base
        new basicDataImportCtrl('#rightWorkspace', {id:'system', subMenuId: data.id})
  })

  new Router(window)

  can.route.ready()

String.prototype.endsWith = (flag = '')->
  return @indexOf(flag) + flag.length == @length
