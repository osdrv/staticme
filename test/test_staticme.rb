require 'helper'
require 'net/http'

class TestStaticme < Test::Unit::TestCase

  def setup
    @params = {
      '--path' => File.join(
        Dir.pwd,
        'test',
        'assets'
      ),
      '--index' => 'index.html',
      '--port' => 8080,
      '--host' => '0.0.0.0'
    }
  end

  should "Serve index.html for the root path" do

    uri = URI::HTTP.build(
      :host => @params['--host'],
      :port => @params['--port'],
      :path => '/'
    )

    Staticme.run! @params do |srv|
      Thread.new do
        Thread.abort_on_exception = true
        sleep 1
        req = Net::HTTP::Get.new(uri.path)
        res = Net::HTTP.start(uri.host, uri.port) { |http|
          http.request(req)
        }
        assert_equal( 200, res.code.to_i )
        assert_equal( res.body, IO.read(
          File.join(
            @params['--path'],
            @params['--index']
          )
        ) )
        srv.stop
      end
    end
  end

end
