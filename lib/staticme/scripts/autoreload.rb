module Staticme

  module Scripts

    module Autoreload

      extend self

      JS_TEMPLATE = <<-eos
(function() {
  window.addEventListener('DOMContentLoaded', function() {
    var location = window.location,
        ws_url   = "ws://" + location.hostname,
        ws       = new WebSocket(ws_url);
    //console.log('Unable to init autoreload websocket.');

    ws.onmessage = function(event) {
      var message = JSON.parse(event.data);
      console.log(message);
    }
  }, false);
})(window);
eos

    def call(arg)
      [200, {:'Content-Type' => 'application/javascript'}, [JS_TEMPLATE]]
    end

    end

  end

end

