
define ['localStorage', 'loading', 'jAlert'], (localStorage, loading)->
  # apiHost = 'http://192.168.1.8:8080/';
  apiHost = 'http://localhost:8080/';
  isLogining = false

  return {
    apiHost: apiHost
    login: (userinfo, done)->
      return if isLogining
      isLogining = true
      $('html').loading({message:'正在登录...'});

      $.getJSON(apiHost + 'main/login', userinfo
        , (data)->
          isLogining = false
          $('html').loading('stop');
          if parseInt(data.status) != 0
            jAlert(data.message, '登陆失败');
          else
            localStorage.set('logined', true);
            localStorage.set('user', data.data);
            window.location.hash = '!home/dashboard/dashboardView'

          done?()
      , (data, status)->
        isLogining = false
        window.location.hash = '!login'
        $('html').loading('stop');
        jAlert('http error:' + status + ' ' + data.statusText, '登陆失败');
        done?()
      )
    logout: ()->
      localStorage.remove('logined');
      localStorage.remove('user');
      document.cookie = ''
      window.location.hash = '!login'
    logined: ()->
      return Boolean(localStorage.get('logined'));
    user: ()->
      return localStorage.get('user');
    userIsAdmin: () ->
      if userInfo = localStorage.get('user')
        if userInfo.roleVoList and Array.isArray userInfo.roleVoList
          for k, v of userInfo.roleVoList
            return true if v.name == '管理员'
      return false
  }
