require 'rubygems'
require 'logger'

require 'staticme/app'
require 'staticme/arguments'
require 'staticme/events/dispatcher'
require 'staticme/events/emitters/file_changed'
require 'staticme/runner'
require 'staticme/thin_runner'
require 'staticme/scripts'
require 'staticme/scripts/autoreload'
require 'staticme/web_socket'

module Staticme

  extend self

  extend Staticme::Arguments

  include Staticme::Events::Dispatcher

  attr_accessor :app,
                :event_dispatcher,
                :logger,
                :params,
                :runner,
                :ws

  def run!(argv, &blk)

    self.params = parse_input(argv)
    self.app = Staticme::App.new(params).bind
    self.logger = ::Logger.new(STDOUT)
    self.logger.level = Logger::DEBUG
    self.runner = Staticme::ThinRunner.new
    self.ws = Staticme::WebSocket.new(params)

    register_event_handlers

    emit(:staticme_inited)

    runner.start(app, params) do |server|
      emit(:web_server_started, server)
      logger.debug('Web server started')
      ws.run!
      blk.call(server) if !blk.nil?
    end
  end

  def broadcast(data)
    begin
      ws.emit(data)
    rescue
      logger.warn('Unable to broadcast event')
    end
  end

  def stop!
    self.emit(:staticme_terminated)
    runner.stop
  end

  private

  def register_event_handlers
    %w(FileChanged).each do |emitter_name|
      klass = Object.const_get "Staticme::Events::Emitters::#{emitter_name}"
      logger.debug("Registering event emitter: #{klass.to_s}")
      emitter = klass.new
      emitter.bind!
    end
  end

end
