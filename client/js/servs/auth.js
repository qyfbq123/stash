

angular.module('authModule', ['ngCookies', 'LocalStorageModule']).factory('Auth', ['$http', '$rootScope', '$state', 'localStorageService',
function($http, $rootScope, $state, localStorageService) {
  var host = $rootScope.apiHost = 'http://192.168.1.3:8080/';

  return {
    login: function (data) {
      $('html').loading({message:'正在登录...'});

      $http.post(host + 'mywms/main/login', data)
      .success(function (data, status) {
        $('html').loading('stop');

        if (parseInt(data.status) != 0) {
          $.messager.alert('登陆失败', data.message, 'error');
        } else {
          localStorageService.set('logined', true);
          localStorageService.set('user', data.data);
          $state.go('home');
        }
      })
      .error(function (data, status) {
        $('html').loading('stop');
        $.messager.alert('登陆失败', 'http error:' + status + ' ' + data, 'error');
      })
    },
    logout: function () {
      localStorageService.set('logined', false);
      localStorageService.remove('user');
    },
    logined:function () {
      return Boolean(localStorageService.get('logined'));
    },
    user: function () {
      return localStorageService.get('user');
    }
  }
}]);
