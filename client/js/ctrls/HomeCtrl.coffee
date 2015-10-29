
define ['can/control', 'can/view/mustache', 'Auth', '_', 'localStorage', 'jAlert'], (Control, can, Auth, un, localStorage)->
  menus = {}
  currentChildMenus = []
  homeCtrl = {}
  homePageData = new can.Map
    username: ''
    childMenuName: '工作区域'

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

  genMenu = (array)->
    _.each array, (menu)->
      if menu.level == 1
        appendTopMenu menu
        menus[menu.id] = menu
      else
        menus[menu.pid] ?= {}
        menus[menu.pid].childMenu ?= []
        menus[menu.pid].childMenu.push menu

    localStorage.set 'menus', menus

    $('#tabs li a').each (i, el)->
      $(el).bind('click', ()->
        $('#tabs li a').removeClass 'active-tab'
        $(el).addClass 'active-tab'
      )

  appendTopMenu = (menu)->
    icon = getIcon menu.url
    $('#tabs').append("<li><a href=#!home/#{menu.url} class='width100 text-center #{icon}'> #{menu.name}</li>")

  appendChildMenu = (fatherId, child)->
    return if !father
    father.append(_.template('<a class="item " href=#!home/<%-url%>><p><b><%-name%></b></p></a>')(child));

  return Control.extend
    init: ()->
      homePageData.attr 'username', Auth.user()?.username

      this.element.html can.view('../../public/view/home/home.html', homePageData)

      can.route.bind "change", (ev, attr, how, newVal, oldVal)=>
        newVal ?= ''
        suffix = newVal.split('/')
        suffix = suffix[suffix.length - 1]
        hit = _.find currentChildMenus, (it)-> it.url == suffix
        childMenuName = if hit and hit.name then hit.name else '工作区域'
        homePageData.attr('childMenuName', childMenuName)

      $.get(Auth.apiHost + 'mywms2/user/menu', (data, status)->
        if parseInt(data.status) != 0
          jAlert('获取菜单失败 ' + data.message, '错误');
          Auth.logout()
          return;

        genMenu(data.data);
      ).fail ()->

    updateChildMenu: (data)->
      currentChildMenus = data.childMenu || []
      homePageData.attr('menuName', data.name)

      $('#menuList').empty()
      for menu in currentChildMenus
        $('#menuList').append "<li><a href='#!home/#{data.url}/#{menu.url}'>#{menu.name}</a></li>"
