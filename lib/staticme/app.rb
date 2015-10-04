require 'rack/staticme_builder'
require 'rack/index_file'

module Staticme

  class App

    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def bind
      params = self.params

      Rack::StaticmeBuilder.new do

        index      = params[:index]
        path       = params[:path]

        map '/staticme/autoreload.js' do
          run Staticme::Scripts::Autoreload
        end

        map /^\/.+/ do
          run Rack::Directory.new( path )
        end

        if !index.nil? && File.exists?( File.join( path, index ) )
          map /^\/$/ do
            run Rack::IndexFile.new( File.join( path, index ) )
          end
        end

      end
    end

  end

end
