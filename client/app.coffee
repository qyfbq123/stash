require.config
  baseUrl: '../lib'
  paths:
    _: 'underscore/underscore-min'
    $: 'jquery/dist/jquery.min'
    can: 'CanJS/amd/can'
    loading: 'jquery-loading/dist/jquery.loading.min'
    datagrid: 'jquery.datagrid/jquery.datagrid'
    autocomplete: 'devbridge-autocomplete/dist/jquery.autocomplete.min'

    jqueryEx: '../public/js/servs/jQueryExtend'
    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'

    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'

    clientManagementCtrl: '../public/js/ctrls/ClientManagementCtrl'
    newClientCtrl: '../public/js/ctrls/NewClientCtrl'
    updateClientCtrl: '../public/js/ctrls/UpdateClientCtrl'

    userManagementCtrl: '../public/js/ctrls/UserManagementCtrl'
    newUserCtrl: '../public/js/ctrls/NewUserCtrl'
    # updateUserCtrl: '../public/js/ctrls/UserManagementCtrl'

  shim:
    can: ['$', 'jqueryEx']
    loading: ['$']
    jqueryEx: ['$']
    datagrid: ['$']
    autocomplete: ['$']

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
        new loginCtrl('body', {})
    'logout route': (data)->
      Auth.logout()
      window.location.hash = '!login'
      delete can.home
      console.log 1
    'route': ()->
      validRoute '', 'empty'
    'home route': (data)->
      require ['homeCtrl', 'clientManagementCtrl', 'userManagementCtrl'], (homeCtrl, clientManagementCtrl, userManagementCtrl)->
        can.home = new homeCtrl('body', {}) if !can.home
    'home/:id route': (data)->
      require ['homeCtrl', 'clientManagementCtrl', 'userManagementCtrl'], (homeCtrl, clientManagementCtrl, userManagementCtrl)->
        can.home = new homeCtrl('body', {}) if !can.home

        switch data.id
          when 'clientManagement'
            new clientManagementCtrl('#currentWork', {})
            can.current = ''
          when 'userManagement'
            new userManagementCtrl('#currentWork', {})
          when 'roleManagement'
            can.current = ''
          when 'outReport'
            can.current = ''
          when 'inReport'
            can.current = ''
  })

  new Router(window)

  can.route.ready()
