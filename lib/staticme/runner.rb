module Staticme

  class Runner

    attr_accessor :server,
                  :server_super

    def start(app, params, &blk)
      server_params = Hash.new
      %w(host port).map(&:to_sym).each do |k|
        (server_params[k.to_s.capitalize.to_sym] = params[k]) if !params[k].nil?
      end
      server_super.run(app, server_params) do |server|
        self.server = server
        blk.call(server) if block_given?
      end
    end

    def stop
      server.stop!
    end

  end

end
