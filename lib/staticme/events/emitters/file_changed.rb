require 'rubygems'
require 'rb-fsevent'

module Staticme

  module Events

    module Emitters

      class FileChanged

        attr_accessor :fsevent

        def initialize
          self.fsevent = FSEvent.new
        end

        def bind!

          params = Staticme.params

          Staticme.on(:fs_changed) do
            Staticme.broadcast(:event => 'fs_change')
          end.on(:staticme_terminated) do
            self.stop!
          end

          fsevent.watch params[:path] do |dirs|
            Staticme.logger.info 'FS change, publishing the event.'
            Staticme.emit(:fs_changed, dirs)
          end

          Thread.new do
            fsevent.run
          end

        end

        def stop!
          fsevent.stop
        end

      end

    end

  end

end
