require 'rubygems'

require './staticme/app'
require './staticme/arguments'
require './staticme/events/dispatcher'
require './staticme/events/emitters/file_changed'
require './staticme/runner'
require './staticme/thin_runner'
require './staticme/scripts'
require './staticme/scripts/autoreload'
require './staticme/web_socket'

module Staticme

  extend self

  extend Staticme::Arguments

  attr_accessor :app,
                :event_dispatcher,
                :params,
                :runner,
                :ws

  def run!(argv, &blk)

    self.params = parse_input(argv)

    self.app = Staticme::App.new(params).bind

    self.event_dispatcher = Staticme::Events::Dispatcher.new

    self.runner = Staticme::ThinRunner.new

    self.ws = Staticme::WebSocket.new(params)

    event_dispatcher.emit(:staticme_inited)

    register_event_handlers

    runner.start(app, params) do |server|
      event_dispatcher.emit(:web_server_started, server)
      ws.run!
      blk.call(server) if !blk.nil?
    end
  end

  def stop!
    event_dispatcher.emit(:staticme_terminated)
    runner.stop
  end

  private

  def register_event_handlers
    fs_emitter = Staticme::Events::Emitters::FileChanged.new(self)
    event_dispatcher.on(:fs_changed) do
      puts 'about to broadcast data to ws clients'
      ws.emit(:event => 'fs_change')
    end.on(:staticme_terminated) do
      fs_emitter.stop!
    end
    fs_emitter.bind!
  end

end
