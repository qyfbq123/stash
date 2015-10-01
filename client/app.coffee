require.config
  baseUrl: '../lib'
  paths:
    _: 'underscore/underscore-min'
    $: 'jquery/dist/jquery.min'
    can: 'CanJS/amd/can'
    easyui: 'jquery-easyui/jquery.easyui.min'
    loading: 'jquery-loading/dist/jquery.loading.min'

    localStorage: '../public/js/servs/local-storage'
    Auth: '../public/js/servs/auth'
    homeCtrl: '../public/js/ctrls/HomeCtrl'
    loginCtrl: '../public/js/ctrls/LoginCtrl'
    clientManagementCtrl: '../public/js/ctrls/ClientManagementCtrl'
  shim:
    can: ['$']
    loading: ['$']
    easyui: ['$']

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
    'route': ()->
      validRoute '', 'empty'
    'home route': (data)->
      console.log 'start home', data
      require ['homeCtrl'], (homeCtrl)->
        this.Home = new homeCtrl('body', {})
    'home/:id route': (data)->
      console.log 'child home', data
      require ['homeCtrl', 'clientManagementCtrl'], (homeCtrl, clientManagementCtrl)->
        this.Home = new homeCtrl('body', {}) if !this.Home

        # this.current?.destroy()
        switch data.id
          when 'clientManagement'
            this.current = new clientManagementCtrl('#currentWork', {})
          when 'userManagement'
            this.current = ''
          when 'roleManagement'
            this.current = ''
          when 'outReport'
            this.current = ''
          when 'inReport'
            this.current = ''
  })

  new Router(window)

  can.route.ready()
