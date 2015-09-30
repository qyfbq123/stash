define ['can/control', 'can/view/mustache'], (Control, can)->
  return Control.extend
    init: ()->
      this.element.html can.view '../../public/view/home/home.html',
        message: 'CanJS'
