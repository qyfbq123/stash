
define ['_'], (un)->
  return {
    set: (key, value)->
      if _.isObject value
        value = JSON.stringify(value)

      window.localStorage.setItem key, value
    get: (key)->
      data = window.localStorage.getItem key
      try
        data = JSON.parse data
      catch e
      return data

    remove: (key)->
      window.localStorage.removeItem key
  }
