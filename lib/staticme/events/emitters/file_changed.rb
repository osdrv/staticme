require 'rubygems'
require 'rb-fsevent'

module Staticme

  module Events

    module Emitters

      class FileChanged

        attr_accessor :app,
                      :fsevent

        def initialize(app)
          self.app = app
          puts 'FSEvent instance would be created'
          self.fsevent = FSEvent.new
          puts 'FSEvent instance has been created'
        end

        def bind!
          event_dispatcher = app.event_dispatcher
          params = app.params
          fsevent.watch params[:path] do |dirs|
            puts 'FS change, broadcasting the event'
            event_dispatcher.emit(:fs_changed, dirs)
          end
          puts "About to run"
          Thread.new do
            fsevent.run
          end
          puts "Run!"
        end

        def stop!
          fsevent.stop
        end

      end

    end

  end

end
