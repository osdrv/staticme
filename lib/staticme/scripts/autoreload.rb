module Staticme

  module Scripts

    module Autoreload

      extend self

      def js_output
        <<-eos
(function() {
  window.addEventListener('DOMContentLoaded', function() {

    var WS_RECONNECT_TIMEOUT = 1000;

    var Dispatcher = function(routes) {
      this.init(routes);
    }

    Dispatcher.prototype.init = function(routes) {
      this.routes = routes;
    }

    Dispatcher.prototype.dispatch = function(message) {
      console.log('Dispatching data: ', message);
      var event_name = message.event;
      if (this.routes[event_name]) {
        this.routes[event_name](message);
      }
    }

    var location   = window.location,
        ws_url     = "ws://" + location.hostname + ':#{Staticme.params[:ws_port].to_i}',
        dispatcher = new Dispatcher({
          'fs_change': function() {
            console.log('Remote fs change, reloading the page...');
            window.location.reload();
          }
        }),
        ws = _open_ws(),
        _reconnect_timer;

    function _open_ws() {

      if (ws) {
        _close_ws();
      }

      ws = new WebSocket(ws_url);

      ws.onopen = function() {
        window.clearTimeout(_reconnect_timer);
        console.info('WebSocket connection has been established.');
      }

      ws.onmessage = function(event) {
        var message = JSON.parse(event.data);
        console.info('A new message received: ' . message);
        dispatcher.dispatch(message);
      }

      ws.onerror = function(e) {
        window.clearTimeout(_reconnect_timer);
        console.error('An unexpected error occured.', e);
        _reconnect_timer = window.setTimeout(_open_ws, WS_RECONNECT_TIMEOUT);
      }

      ws.onclose = function() {
        window.clearTimeout(_reconnect_timer);
        console.warn('WebSocket connection has been closed by the server.');
        _reconnect_timer = window.setTimeout(_open_ws, WS_RECONNECT_TIMEOUT);
      }

      return ws;
    }

    function _close_ws() {
      ws.close();
      ws = null;
    }

  }, false);
})(window);
eos
    end

    def call(arg)
      [200, {:'Content-Type' => 'application/javascript'}, [js_output]]
    end

    end

  end

end

