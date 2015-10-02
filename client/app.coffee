require.config
  baseUrl: '../lib'
  paths:
    _: 'underscore/underscore-min'
    $: 'jquery/dist/jquery.min'
    can: 'CanJS/amd/can'
    easyui_lang: 'jquery-easyui/locale/easyui-lang-zh_CN'
    easyui: 'jquery-easyui/jquery.easyui.min'
    loading: 'jquery-loading/dist/jquery.loading.min'

    jqueryEx: '../public/js/servs/jQueryExtend'
    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'
    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'
    clientManagementCtrl: '../public/js/ctrls/ClientManagementCtrl'
    newClientCtrl: '../public/js/ctrls/NewClientCtrl'
    updateClientCtrl: '../public/js/ctrls/UpdateClientCtrl'
  shim:
    can: ['$', 'jqueryEx']
    loading: ['$']
    easyui: ['$', 'easyui_lang']

require ['can', 'Auth'], (can, Auth)->
  validRoute = (route, p)->
    if !Auth.logined() && route != 'login'
      console.log 'to login...'
      window.location.hash = '!login'
    else if !route
      console.log "to home..."
      window.location.hash = '!home'
    else
      console.log "to #{route}..."

  Router = can.Control({
    '{can.route} change': (ev, attr, how, newVal, oldVal)->
      # console.log(JSON.stringify(ev), ev.route, '---------')
      validRoute ev.route, 'change'
    'login route': (data)->
      require ['loginCtrl'], (loginCtrl)->
        can.loginCtrl = new loginCtrl('body', {}) unless can.loginCtrl
    'logout route': (data)->
      Auth.logout()
      window.location.hash = '!login'
    'route': ()->
      validRoute '', 'empty'
    'home route': (data)->
      require ['homeCtrl'], (homeCtrl)->
        can.Home = new homeCtrl('body', {}) unless can.Home
    'home/:id route': (data)->
      require ['homeCtrl', 'clientManagementCtrl'], (homeCtrl, clientManagementCtrl)->
        can.Home = new homeCtrl('body', {}) unless can.Home

        switch data.id
          when 'clientManagement'
            can.clientManagementCtrl = new clientManagementCtrl('#currentWork', {}) unless can.clientManagementCtrl
          when 'userManagement'
            can.current = ''
          when 'roleManagement'
            can.current = ''
          when 'outReport'
            can.current = ''
          when 'inReport'
            can.current = ''
  })

  new Router(window)

  can.route.ready()
