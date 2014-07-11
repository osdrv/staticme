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

  should 'Serve index.html for the root path' do

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

  should 'Serve file by exact name' do

    file_name = 'index2.html'

    uri = URI::HTTP.build(
      :host => @params['--host'],
      :port => @params['--port'],
      :path => "/#{file_name}"
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
            file_name
          )
        ) )
        srv.stop
      end
    end
  end

  should 'Serve index file other than index.html if provided' do

    file_name = 'index2.html'

    local_params = @params
    local_params['--index'] = file_name


    uri = URI::HTTP.build(
      :host => local_params['--host'],
      :port => local_params['--port'],
      :path => "/",
      :index => file_name
    )

    Staticme.run! local_params do |srv|
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
            local_params['--path'],
            file_name
          )
        ) )
        srv.stop
      end
    end
  end

  should 'Not serve absent file' do

    file_name = 'index3.html'

    uri = URI::HTTP.build(
      :host => @params['--host'],
      :port => @params['--port'],
      :path => "/#{file_name}"
    )

    Staticme.run! @params do |srv|
      Thread.new do
        Thread.abort_on_exception = true
        sleep 1
        req = Net::HTTP::Get.new(uri.path)
        res = Net::HTTP.start(uri.host, uri.port) { |http|
          http.request(req)
        }
        assert_equal( 404, res.code.to_i )
        srv.stop
      end
    end
  end

  should 'Serve autoreload script path' do

    uri = URI::HTTP.build(
      :host => @params['--host'],
      :port => @params['--port'],
      :path => '/staticme/autoreload.js'
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
        srv.stop
      end
    end

  end

  should 'Emit event with parameters given' do
    a0 = [1,23,34]
    b0 = { :c => 1 }
    c0 = "Hello world!"
    event_name = 'test_event'
    dispatcher = Staticme::Events::Dispatcher.new
    test_ran = false

    Thread.new do
      Thread.abort_on_exception = true
      sleep 1
      dispatcher.on event_name do |a1, b1, c1|
        assert_equal(a1, a0)
        assert_equal(b1, b0)
        assert_equal(c1, c0)
        test_ran = true
      end
      dispatcher.emit(event_name, a0, b0, c0)
      assert_equal(test_ran, true)
    end
  end

end
