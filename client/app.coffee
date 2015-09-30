require.config
  baseUrl: '../lib'
  paths:
    underscore: 'underscore/underscore-min'
    jquery: 'jquery/dist/jquery.min'
    can: 'CanJS/amd/can'
    easyui: 'jquery-easyui/jquery.easyui.min'
    loading: 'jquery-loading/dist/jquery.loading.min'
    homeCtrl: '../public/js/HomeCtrl'

require ['homeCtrl'], (homeCtrl)->
  new homeCtrl('body', {});



# var app = angular.module('stashApp', ['ui.router', 'homeModule', 'loginModule', 'authModule', 'LocalStorageModule']);

# app.config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function($stateProvider, $urlRouterProvider, $locationProvider) {
#   $stateProvider.state('login', {
#     url: '/login',
#     templateUrl: './views/login.html',
#     controller: 'loginCtrl'
#   })

#   $stateProvider.state('logout', {
#     url: '/logout',
#     template:'<p> logout',
#     controller: function ($state, Auth) {
#       Auth.logout();
#       $state.go('login');
#     }
#   })

#   $stateProvider.state('home', {
#     url: '/home',
#     templateUrl: './views/home/home.html',
#     controller: 'homeCtrl'
#   })
#   .state('home.clientManagement', {
#     url: '/clientManagement',
#     templateUrl: './views/home/client-management/client-management.html',
#     controller: 'clientManagementCtrl'
#   })
#   // .state('home.inReport', {
#   //   url: '/inReport',
#   //   templateUrl: './views/inReport.html'
#   // })
#   // .state('home.roleManagement', {
#   //   url: '/roleManagement',
#   //   templateUrl: './views/roleManagement.html'
#   // })
#   // .state('home.outReport', {
#   //   url: '/outReport',
#   //   templateUrl: './views/outReport.html'
#   // })

#   $urlRouterProvider.otherwise('/home');
# }]);


# // angular http请求默认是在payload中
# app.config(function($httpProvider){
#   $httpProvider.defaults.transformRequest = function(obj){
#     var str = [];
#     for(var p in obj) {
#        str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
#     }
#     return str.join("&");
#   }
#   $httpProvider.defaults.headers.post = {
#     'Content-Type': 'application/x-www-form-urlencoded'
#   }
# });

# app.config(function (localStorageServiceProvider) {
#   localStorageServiceProvider.setPrefix('stash')
# });
