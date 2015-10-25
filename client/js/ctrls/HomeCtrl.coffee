
define ['can/control', 'can/view/mustache', 'Auth', '_', 'localStorage'], (Control, can, Auth, un, localStorage)->
  menus = {}
  data = new can.Map
    username: ''

  genLeftMenu = (array)->
    _.each array, (menu)->
      if menu.level == 1
        appendTopMenu menu
        menus[menu.id] = menu
      else
        menus[menu.pid] ?= {}
        menus[menu.pid].childMenu ?= []
        menus[menu.pid].childMenu.push menu

    console.log menus
    localStorage.set 'menus', menus

    $('#tabs li a').each (i, el)->
      $(el).bind('click', ()->
        $('#tabs li a').removeClass 'active-tab'
        $(el).addClass 'active-tab'
      )


  getIcon = (url)->
    if url == 'dashboard'
      return 'dashboard-tab'
    else if url == 'company'
      return 'customers-tab'
    else if url == 'goodsIn'
      return 'purchase-tab'
    else if url == 'stocksproducts'
      return 'stock-tab'
    else if url == 'location'
      return 'sales-tab'
    else if url == 'goodsOut'
      return 'supplier-tab'
    else if url == 'report'
      return 'report-tab'
    else if url == 'system'
      return 'button menu-settings image-left'

  appendTopMenu = (menu)->
    icon = getIcon menu.url
    $('#tabs').append("<li><a href=#!home/#{menu.url} class='width100 text-center #{icon}'> #{menu.name}</li>")

  appendChildMenu = (fatherId, child)->
    return if !father
    father.append(_.template('<a class="item " href=#!home/<%-url%>><p><b><%-name%></b></p></a>')(child));

  return Control.extend
    init: ()->
      this.element.html can.view('../../public/view/home/home.html', data)

      data.attr 'username', Auth.user()?.username

      $.get(Auth.apiHost + 'mywms2/user/menu', (data, status)->

        if parseInt(data.status) != 0
          # $.messager.alert('错误', '获取菜单失败 ' + data.message, 'error');
          return;

        genLeftMenu(data.data);

      ).fail ()->
