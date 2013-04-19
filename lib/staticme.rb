require 'rubygems'
require 'rack'
require 'thin'

module Staticme
  extend self

  def run!(argv)
    pwd = argv['-f'] || argv['--path'] || Dir.pwd
    port = (argv['-p'] || argv['--port'] || 8080).to_i
    host = argv['-h'] || argv['--host'] || '0.0.0.0'
    staticme = Rack::Builder.new do
      run Rack::Directory.new(pwd)
    end

    Rack::Handler::Thin.run(staticme, :Port => port, :Host => host)
  end
end
