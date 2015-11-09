require.config
  baseUrl: '../lib'
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
    fileInput: 'bootstrap-fileinput/js/fileinput.min'
    fileInputZh: 'bootstrap-fileinput/js/fileinput_locale_zh'
    imageView: 'magnific-popup/dist/jquery.magnific-popup.min'
    dateTimePicker: 'datetimepicker/jquery.datetimepicker'
    printer: 'jQuery.print/jQuery.print'

    jqueryEx: '../public/js/servs/jQueryExtend'
    jAlert: '../public/js/plugins/jquery.alerts'
    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'

    base: '../public/js/ctrls/base'
    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'
    imageManageCtrl: '../public/js/ctrls/ImageManageCtrl'

    dashboardCtrl: '../public/js/ctrls/dashboardCtrl'

    # 公司下的控制器
    companyNewCtrl: '../public/js/ctrls/company/companyNewCtrl'
    companyViewCtrl: '../public/js/ctrls/company/companyViewCtrl'
    userNewCtrl: '../public/js/ctrls/company/userNewCtrl'
    userViewCtrl: '../public/js/ctrls/company/userViewCtrl'

    # 库存 & 商品
    stockViewCtrl: '../public/js/ctrls/stocksproducts/stock'
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
    loading: ['$']
    jqueryEx: ['$']
    datagrid: ['$']
    jAlert: ['$']
    datagrid_plugin: ['datagrid']
    autocomplete: ['$']
    validate: ['$']
    fileInputZh: ['fileInput', '$']
    dateTimePicker: ['$']

require ['can', 'Auth', 'localStorage'], (can, Auth, localStorage)->
  validRoute = (route, p)->
    if !Auth.logined() && route != 'login'
      window.location.hash = '!login'
    else if !route
      window.location.hash = '!home'

  Router = can.Control({
    '{can.route} change': (ev, attr, how, newVal, oldVal)->
      validRoute ev.route, 'change'

    'login route': (data)->
      require ['loginCtrl'], (loginCtrl)->
        new loginCtrl('body', {})
    'logout route': (data)->
      Auth.logout()
      delete can.home
    'route': ()->
      window.location.hash = '!login'
    'home route': (data)->
      require ['base'], (base)->
        new base('', {id:'dashboard'})
    'home/:id route': (data)->
      require ['base'], (base)->
        new base('', data)

    'home/dashboard/dashboard route': (data)->
      require ['dashboardCtrl'], (dashboardCtrl)->
        new dashboardCtrl('#rightWorkspace', {id:'dashboard'})

    'home/company/companyAdd route': (data)->
      require ['companyNewCtrl'], (companyNewCtrl)->
        new companyNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/companyAdd/:id route': (data)->
      require ['companyNewCtrl'], (companyNewCtrl)->
        new companyNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/companyView route': (data)->
      require ['companyViewCtrl'], (companyViewCtrl)->
        new companyViewCtrl('#rightWorkspace', {id:'company'})

    'home/company/userAdd route': (data)->
      require ['userNewCtrl'], (userNewCtrl)->
        new userNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/userAdd/:id route': (data)->
      require ['userNewCtrl'], (userNewCtrl)->
        new userNewCtrl('#rightWorkspace', {id:'company'})
    'home/company/userView route': (data)->
      require ['userViewCtrl'], (userViewCtrl)->
        new userViewCtrl('#rightWorkspace', {id:'company'})

    'home/goodsOut/goodsOutAdd route': (data)->
      require ['goodsOutCreateCtrl'], (goodsOutCreateCtrl)->
        new goodsOutCreateCtrl('#rightWorkspace', {id:'goodsOut'})
    'home/goodsOut/goodsOutAdd/:id route': (data)->
      require ['goodsOutCreateCtrl'], (goodsOutCreateCtrl)->
        new goodsOutCreateCtrl('#rightWorkspace', {id:'goodsOut'})
    'home/goodsOut/goodsOutView route': (data)->
      require ['goodsOutViewCtrl'], (goodsOutViewCtrl)->
        new goodsOutViewCtrl('#rightWorkspace', {id:'goodsOut'})

    'home/goodsIn/goodsInAdd route': (data)->
      require ['goodsInCreateCtrl'], (goodsInCreateCtrl)->
        new goodsInCreateCtrl('#rightWorkspace', {id:'goodsIn'})
    'home/goodsIn/goodsInAdd/:id route': (data)->
      require ['goodsInViewCtrl'], (goodsInViewCtrl)->
        new goodsInViewCtrl('#rightWorkspace', {id:'goodsIn'})
    'home/goodsIn/goodsInView route': (data)->
      require ['goodsInViewCtrl'], (goodsInViewCtrl)->
        new goodsInViewCtrl('#rightWorkspace', {id:'goodsIn'})

    'home/stocksproducts/stock route': (data)->
      require ['stockViewCtrl'], (stockViewCtrl)->
        new stockViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/stockItemAdd route': (data)->
      require ['stockItemCreateCtrl'], (stockItemCreateCtrl)->
        new stockItemCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/stockItemAdd/:id route': (data)->
      require ['stockItemCreateCtrl'], (stockItemCreateCtrl)->
        new stockItemCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/stockItemView route': (data)->
      require ['stockItemViewCtrl'], (stockItemViewCtrl)->
        new stockItemViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/brandAdd route': (data)->
      require ['brandCreateCtrl'], (brandCreateCtrl)->
        new brandCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/brandAdd/:id route': (data)->
      require ['brandCreateCtrl'], (brandCreateCtrl)->
        new brandCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/brandView route': (data)->
      require ['brandViewCtrl'], (brandViewCtrl)->
        new brandViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/categoryAdd route': (data)->
      require ['categoryCreateCtrl'], (categoryCreateCtrl)->
        new categoryCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/categoryAdd/:id route': (data)->
      require ['categoryCreateCtrl'], (categoryCreateCtrl)->
        new categoryCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/categoryView route': (data)->
      require ['categoryViewCtrl'], (categoryViewCtrl)->
        new categoryViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/supplierAdd route': (data)->
      require ['supplierNewCtrl'], (supplierNewCtrl)->
        new supplierNewCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/supplierAdd/:id route': (data)->
      require ['supplierNewCtrl'], (supplierNewCtrl)->
        new supplierNewCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/supplierView route': (data)->
      require ['supplierViewCtrl'], (supplierViewCtrl)->
        new supplierViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/stocksproducts/consigneeAdd route': (data)->
      require ['consigneeCreateCtrl'], (consigneeCreateCtrl)->
        new consigneeCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/consigneeAdd/:id route': (data)->
      require ['consigneeCreateCtrl'], (consigneeCreateCtrl)->
        new consigneeCreateCtrl('#rightWorkspace', {id:'stocksproducts'})
    'home/stocksproducts/consigneeView route': (data)->
      require ['consigneeViewCtrl'], (consigneeViewCtrl)->
        new consigneeViewCtrl('#rightWorkspace', {id:'stocksproducts'})

    'home/location/warehouseAdd route': (data)->
      require ['warehouseAddCtrl'], (warehouseAddCtrl)->
        new warehouseAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/warehouseAdd/:id route': (data)->
      require ['warehouseAddCtrl'], (warehouseAddCtrl)->
        new warehouseAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/warehouseView route': (data)->
      require ['warehouseViewCtrl'], (warehouseViewCtrl)->
        new warehouseViewCtrl('#rightWorkspace', {id:'location'})

    'home/location/locationAdd route': (data)->
      require ['locationAddCtrl'], (locationAddCtrl)->
        new locationAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/locationAdd/:id route': (data)->
      require ['locationAddCtrl'], (locationAddCtrl)->
        new locationAddCtrl('#rightWorkspace', {id:'location'})
    'home/location/locationView route': (data)->
      require ['locationViewCtrl'], (locationViewCtrl)->
        new locationViewCtrl('#rightWorkspace', {id:'location'})

    'home/report/:id route': (data)->
      require ['exportReportsCtrl'], (exportReportsCtrl)->
        new exportReportsCtrl('#rightWorkspace', {id:'report', subMenuId: data.id})

    'home/system/:id route': (data)->
      require ['basicDataImportCtrl'], (basicDataImportCtrl)->
        new basicDataImportCtrl('#rightWorkspace', {id:'system', subMenuId: data.id})
  })

  new Router(window)

  can.route.ready()
