
define ['localStorage', 'loading', 'jAlert'], (localStorage, loading)->
  apiHost = 'http://192.168.0.110:8080/';

  return {
    apiHost: apiHost
    login: (userinfo, done)->
      $('html').loading({message:'正在登录...'});

      $.post(apiHost + 'main/login', userinfo, (data, status)->

        $('html').loading('stop');

        if parseInt(data.status) != 0
          jAlert(data.message, '登陆失败');
        else
          localStorage.set('logined', true);
          localStorage.set('user', data.data);
          window.location.hash = '!home'
        done?()
      )
      .fail((data, status)->
        window.location.hash = '!login'
        $('html').loading('stop');
        jAlert('http error:' + status + ' ' + data.statusText, '登陆失败');
        done?()
      )
    logout: ()->
      localStorage.remove('logined');
      localStorage.remove('user');
      document.cookie = ''
      window.location.hash = '#!login'
    logined: ()->
      return Boolean(localStorage.get('logined'));
    user: ()->
      return localStorage.get('user');
  }
