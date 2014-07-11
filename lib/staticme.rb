require 'rubygems'

require 'staticme/app'
require 'staticme/arguments'
require 'staticme/events/dispatcher'
require 'staticme/runner'
require 'staticme/thin_runner'
require 'staticme/scripts'
require 'staticme/scripts/autoreload'
require 'staticme/web_socket'

module Staticme

  extend self

  extend Staticme::Arguments

  attr_accessor :runner

  def run!(argv, &blk)

    params = parse_input(argv)

    app = Staticme::App.new(params).bind

    runner = Staticme::ThinRunner.new

    runner.start(app, params, &blk)

  end

  def stop!
    runner.stop
  end

end
