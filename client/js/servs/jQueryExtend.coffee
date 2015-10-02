
define ['$'], ()->
  $.getJSON = (url, data, success, error)->
    return jQuery.ajax
      headers:
          'Accept': 'application/json'
          'Content-Type': 'application/json'
      'type': 'GET'
      'url': url
      'data': data
      'success': success
      'error': error

  $.postJSON = (url, data, success, error)->
    return jQuery.ajax
      headers:
          'Accept': 'application/json'
          'Content-Type': 'application/json'
      'type': 'POST'
      'url': url
      'data': JSON.stringify(data)
      'dataType': 'json'
      'success': success
      'error': error
