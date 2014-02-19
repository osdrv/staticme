require 'rack'
require 'thin'
require 'staticme/runner'

module Staticme

  class ThinRunner < Runner

    def initialize
      self.server_super = Rack::Handler::Thin
    end

  end

end