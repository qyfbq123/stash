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

    jqueryEx: '../public/js/servs/jQueryExtend'
    jAlert: '../public/js/plugins/jquery.alerts'
    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'

    base: '../public/js/ctrls/base'
    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'

    # 公司下的控制器
    companyNewCtrl: '../public/js/ctrls/company/companyNewCtrl'
    companyViewCtrl: '../public/js/ctrls/company/companyViewCtrl'
    userNewCtrl: '../public/js/ctrls/company/userNewCtrl'
    userViewCtrl: '../public/js/ctrls/company/userViewCtrl'

  shim:
    can: ['$', 'jqueryEx']
    loading: ['$']
    jqueryEx: ['$']
    datagrid: ['$']
    jAlert: ['$']
    datagrid_plugin: ['datagrid']
    autocomplete: ['$']
    validate: ['$']

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
      window.location.hash = '!login'
      delete can.home
    'route': ()->
      window.location.hash = '#!home'
    'home route': (data)->
      require ['base'], (base)->
        new base('', {id:'dashboard'})
    'home/:id route': (data)->
      require ['base'], (base)->
        new base('', data)

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
  })

  new Router(window)

  can.route.ready()
