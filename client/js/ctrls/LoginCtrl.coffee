
define ['can/control', 'can/view/mustache', 'Auth'], (Control, can, Auth)->
  if Auth.logined()
    window.location.hash = '!home'

  userInfo = new can.Map
    username: 'admin'
    password: 'admin'

  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/login.html', userInfo)

    '.login_button click': ()->
      Auth.login userInfo.attr(), ()=> @destroy()
    '.reset_botton click': ()->
      userInfo.attr 'username', ''
      userInfo.attr 'password', ''
