

angular.module('homeModule', []).controller('homeCtrl', ['$rootScope', '$scope', '$http', '$state', 'Auth',
  function($rootScope, $scope, $http, $state, Auth) {
    if (!Auth.logined())
      return $state.go('login');

    $('#mainLayout').layout()
    $('#leftMenu').accordion();

    $scope.username = Auth.user().username;
    console.log(Auth.user());
    $('#username')[0].innerText  = $scope.username;

    var isFirst = true;
    $http.get($rootScope.apiHost + 'mywms/main/menu').success(function (data, status) {
      if (parseInt(data.status) != 0) {
        $.messager.alert('错误', '获取菜单失败 ' + data.message, 'error');
        return;
      }

      genLeftMenu(data.data);
    })

    $scope.clickMenu = function (url) {
      console.log('click ' + url);
    }

    function genLeftMenu (array) {
      _.each(array, function(menu) {
        appendMenu(menu);
      });
    }

    function appendMenu (menu) {
      if (menu.level == 1)
        $('#leftMenu').accordion('add', {title: menu.name, selected: isFirst});
      else if (menu.level > 1 && menu.pid)
        appendChildMenu(menu.pid, menu);
      isFirst = false;
    }

    function appendChildMenu (fatherId, child) {
      var father = $('#leftMenu').accordion('getPanel', fatherId - 1);
      if (!father) return;

      father.append(_.template('<a ui-sref="home.userManagement" class="item " href=#/home/<%-url%>><p><b><%-name%></b></p></a>')(child));
    }
  }
]);
