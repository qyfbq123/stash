

angular.module('loginModule', []).controller('loginCtrl', ['$rootScope', '$scope', '$http', '$state', 'Auth',
  function($rootScope, $scope, $http, $state, Auth) {
    $scope.username = 'admin';
    $scope.password = 'admin';
    $scope.isLogin = true;

    if (Auth.logined())
      $state.go('home');

    $scope.doLogin = function (argument) {
      if (!$scope.username || !$scope.password) {
        $.messager.alert('登陆失败', '请输入账号和密码！', 'error');
      } else {
        var data = {username: $scope.username, password: $scope.password};
        Auth.login(data);
      }
    }

    $scope.doReset = function (argument) {
      $scope.username = '';
      $scope.password = '';
    }
  }
]);
