
define ['can/control', 'can/view/mustache', 'Auth'], (Control, can, Auth)->
  if Auth.logined()
    window.location.hash = '!home/dashboard/dashboardView'

  userInfo = new can.Map
    username: ''
    password: ''

  return Control.extend
    init: ()->
      this.element.html can.view('../public/view/login.html', userInfo)

      $('input.login').keyup (e)->
        if e.keyCode == 13
          $(this).blur()
          Auth.login userInfo.attr()

      $('.login_button').unbind 'click', ()->
      $('.login_button').bind 'click', ()->
        Auth.login userInfo.attr()

      $('.reset_botton').unbind 'click', ()->
      $('.reset_botton').bind 'click', ()->
        userInfo.attr 'username', ''
        userInfo.attr 'password', ''
