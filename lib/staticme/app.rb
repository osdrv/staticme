module Staticme

  class App

    attr_accessor :params

    def initialize(params)
      self.params = params
    end

    def bind
      params = self.params
      Rack::Builder.new do
        index = params[:index]
        path = params[:path]

        if !index.nil? && File.exists?( File.join( path, index ) )
          map '/' do
            run Rack::File.new( File.join( path, index ) )
          end
        end
        run Rack::Directory.new( path )
      end
    end

  end

end