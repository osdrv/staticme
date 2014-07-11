module Staticme

  class Runner

    attr_accessor :server,
                  :server_super,
                  :ws

    def start(app, params, &blk)
      server_super.run(app, params) do |server|
        self.server = server
        self.ws = Staticme::WebSocket.new(params)
        self.ws.run! do
          blk.call(server) if block_given?
        end
      end
    end

    def stop
      server.stop!
      ws.stop!
    end

  end

end
