
define ['can/control', 'can/view/mustache', 'Auth'], (Control, can, Auth)->
  if Auth.logined()
    window.location.hash = '!home/dashboard/dashboardView'

  userInfo = new can.Map
    username: ''
    password: ''

  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/login.html', userInfo)

      $('input.login').keyup (e)->
        Auth.login userInfo.attr() if e.keyCode == 13

      $('.login_button').unbind 'click', ()->
      $('.login_button').bind 'click', ()->
        Auth.login userInfo.attr()

      $('.reset_botton').unbind 'click', ()->
      $('.reset_botton').bind 'click', ()->
        userInfo.attr 'username', ''
        userInfo.attr 'password', ''
