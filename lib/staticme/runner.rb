module Staticme

  class Runner

    attr_accessor :server,
                  :server_super

    def start(app, params, &blk)
      server_super.run(app, params) do |server|
        self.server = server
        blk.call(server) if block_given?
      end
    end

    def stop
      server.stop!
    end

  end

end