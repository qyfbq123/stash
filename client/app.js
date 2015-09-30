// Generated by CoffeeScript 1.10.0
require.config({
  baseUrl: '../lib',
  paths: {
    _: 'underscore/underscore-min',
    $: 'jquery/dist/jquery.min',
    can: 'CanJS/amd/can',
    easyui: 'jquery-easyui/jquery.easyui.min',
    loading: 'jquery-loading/dist/jquery.loading.min',
    localStorage: '../public/js/servs/local-storage',
    Auth: '../public/js/servs/auth',
    homeCtrl: '../public/js/ctrls/HomeCtrl',
    loginCtrl: '../public/js/ctrls/LoginCtrl'
  },
  shim: {
    can: ['$'],
    loading: ['$'],
    easyui: ['$']
  }
});

require(['can', 'Auth'], function(can, Auth) {
  var Router, validRoute;
  validRoute = function(route, p) {
    if (!Auth.logined() && route !== 'login') {
      console.log('to login...');
      return window.location.hash = '!login';
    } else if (!route) {
      console.log("to home...");
      return window.location.hash = '!home';
    } else {
      return console.log("to " + route + "...");
    }
  };
  Router = can.Control({
    '{can.route} change': function(ev, attr, how, newVal, oldVal) {
      console.log(JSON.stringify(ev), ev.route, '---------');
      return validRoute(ev.route, 'change');
    },
    'home route': function(data) {
      console.log('start home');
      return require(['homeCtrl'], function(homeCtrl) {
        return new homeCtrl('body', {});
      });
    },
    'login route': function(data) {
      console.log('start login');
      return require(['loginCtrl'], function(loginCtrl) {
        return new loginCtrl('body', {});
      });
    },
    'logout route': function(data) {
      Auth.logout();
      return window.location.hash = '!login';
    },
    'route': function() {
      return validRoute('', 'empty');
    }
  });
  new Router(window);
  return can.route.ready();
});
