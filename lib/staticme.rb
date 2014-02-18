require 'rubygems'
require 'rack'
require 'thin'

module Staticme

  extend self

  attr_accessor :server

  ARGS  = {
    :path   => {
      :short      => 'f',
      :default    => Proc.new { Dir.pwd }
    },
    :port   => {
      :short    => 'p',
      :default    => 8080,
      :sanitizer  => Proc.new { |v| v.to_i }
    },
    :host   => {
      :short      => 'h',
      :default    => '0.0.0.0'
    },
    :index  => {
      :short      => 'i',
      :default    => 'index.html'
    }
  }

  def run!(argv, &blk)

    params = Hash.new

    ARGS.each_pair do |param_name, param_attrs|
      param_shorten_name = param_attrs[:shorten]
      default = param_attrs[:default]
      sanitizer = param_attrs[:sanitizer]
      param_value = argv["--#{param_name}"] ||
                    ( param_shorten_name.nil? ? nil : argv["-#{param_shorten_name}"] ) ||
                    ( default.is_a?(Proc) ? default.call : default )
      ( param_value = sanitizer.call( param_value ) ) if sanitizer.is_a? Proc

      if !param_value.nil?
        params[param_name] = param_value
      end

    end

    staticme_app = Rack::Builder.new do

      index = params[:index]
      path = params[:path]

      if !index.nil? && File.exists?( File.join( path, index ) )
        map '/' do
          run Rack::File.new( File.join( path, index ) )
        end
      end
      run Rack::Directory.new( path )
    end

    Rack::Handler::Thin.run(
      staticme_app,
      {
        :Port => params[:port],
        :Host => params[:host]
      }
    ) do |server|
      self.server = server
      blk.call(server) if block_given?
    end

  end

  def stop!
    self.server.stop!
  end

end
