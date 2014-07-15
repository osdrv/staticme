require 'rubygems'
require 'em-websocket'
require 'json'

module Staticme

  class WebSocket

    attr_accessor :params

    def initialize(params)
      self.params = params
      @pool = []
    end

    def run!(&block)
      EM.next_tick do
        puts "Starting WebSocket on ws://#{params[:host]}:#{params[:ws_port]}"
        EM::WebSocket.run(:host => params[:host], :port => params[:ws_port]) do |ws|
          @pool.push ws
          ws.onclose do
            @pool.delete ws
          end
        end
        block.call if block_given?
      end
    end

    def emit(event)
      @pool.each do |ws|
        next if ws.nil?
        ws.send event.to_json
      end
    end

    def stop!
      EM.stop!
      @pool = []
    end

  end

end

