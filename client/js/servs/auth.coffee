
define ['localStorage', 'loading', 'easyui'], (localStorage, loading, easyui)->
  apiHost = 'http://192.168.1.5:8080/';

  return {
    apiHost: apiHost
    login: (userinfo, done)->
      console.log userinfo
      $('html').loading({message:'正在登录...'});

      $.post(apiHost + 'mywms/main/login', userinfo, (data, status)->
        console.log data, status

        $('html').loading('stop');

        if parseInt(data.status) != 0
          $.messager.alert('登陆失败', data.message, 'error');
        else
          localStorage.set('logined', true);
          localStorage.set('user', data.data);
          window.location.hash = '!home'
        done?()
      )
      .fail((data, status)->
        window.location.hash = '!login'
        $('html').loading('stop');
        $.messager.alert('登陆失败', 'http error:' + status + ' ' + data.statusText, 'error');
        done?()
      )
    logout: ()->
      localStorage.remove('logined');
      localStorage.remove('user');
      document.cookie = ''
    logined: ()->
      return Boolean(localStorage.get('logined'));
    user: ()->
      return localStorage.get('user');
    createClient: (userInfo)->
      console.log(userInfo);
  }
