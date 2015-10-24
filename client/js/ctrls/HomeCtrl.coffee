
define ['can/control', 'can/view/mustache', 'Auth', '_'], (Control, can, Auth, un)->
  data = new can.Map
    username: ''

  genLeftMenu = (array)->
    _.each array, (menu)-> appendMenu(menu)

  appendMenu = (menu)->
    console.log menu

    if (menu.level == 1)
      $('#tabs').append("<li><a href=#!#{menu.url} class='width60 text-center'> #{menu.name}</li>")
    # else if (menu.level > 1 && menu.pid)
    #   appendChildMenu(menu.pid, menu);

  #   if (menu.level == 1)
  #     $('#leftMenu').accordion('add', {title: menu.name, selected: isFirst});
  #   else if (menu.level > 1 && menu.pid)
  #     appendChildMenu(menu.pid, menu);
  #   isFirst = false;

  # appendChildMenu = (fatherId, child)->
  #   father = $('#leftMenu').accordion('getPanel', fatherId - 1);
  #   return if !father
  #   father.append(_.template('<a class="item " href=#!home/<%-url%>><p><b><%-name%></b></p></a>')(child));

  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/home/home.html', data)

      # $('#mainLayout').layout()
      # $('#leftMenu').accordion();
      # $('#tabs').tabs();

      data.attr 'username', Auth.user()?.username

      isFirst = true;
      $.get(Auth.apiHost + 'mywms/main/menu', (data, status)->

        if parseInt(data.status) != 0
          $.messager.alert('错误', '获取菜单失败 ' + data.message, 'error');
          return;

        genLeftMenu(data.data);

      ).fail ()->

    'userManagement route': ()->
      console.log 'userManagement'
