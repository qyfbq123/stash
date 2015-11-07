
define ['base', 'can', 'can/control', 'Auth', 'localStorage', '_', 'jAlert', 'validate', 'autocomplete', 'dateTimePicker'], (base, can, Control, Auth, localStorage)->
  return Control.extend
    init: (el, data)->
      opt = {}
      new base('', data) if !can.base
      this.element.html can.view('../../public/view/home/report/exportReports.html', {})

      apiSuffix = ''
      if data.subMenuId == 'operationsReport'
        apiSuffix = '/report/settlementbycompany'
      else if data.subMenuId == 'settlementReportByDate'
        $('.company').remove()
        $('.goods').remove()
        apiSuffix = '/report/settlementbydate'
      else if data.subMenuId == 'settlementReportByGoods'
        $('.startAt').remove()
        $('.endAt').remove()
        $('.company').remove()
        apiSuffix = '/report/settlementbygoods'

      $('#startAt').datetimepicker
        timepicker: false
        lang: 'zh'

      $('#endAt').datetimepicker
        timepicker: false
        lang: 'zh'

      $('#companySelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}mywms2/company/allbyname"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          opt.companyId = suggestion.data.id
      })

      $('#goodSelector').autocomplete({
        minChars:0
        serviceUrl: "#{Auth.apiHost}mywms2/goods/all"
        paramName: 'name'
        dataType: 'json'
        transformResult: (response, originalQuery)->
          query: originalQuery
          suggestions: _.map(response.data, (it)->{value:it.name, data: it})
        onSelect: (suggestion)->
          opt.goodsId = suggestion.data.id
      })

      $('#startExport').unbind 'click'
      $('#startExport').bind('click', ()->
        return if !$('#stockItemCreate').valid()

        if $('#startAt')?[0] and $('#endAt')?[0]
          opt.start = Date.parse($('#startAt')[0].value) / 1000
          opt.end = Date.parse($('#endAt')[0].value) / 1000
          return jAlert '开始时间必须小于结束时间！', '提示' if opt.end <= opt.start

        url = Auth.apiHost + "mywms2#{apiSuffix}?"
        for k, v of opt
          url += "#{k}=#{v}&"

        $('#startExport').attr('href', url)
      )
