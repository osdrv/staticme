require 'rubygems'
require 'rb-fsevent'
require 'digest/md5'

module Staticme

  module Events

    module Emitters

      class FileChanged

        attr_accessor :fsevent
        attr_accessor :_broadcast_tail

        def initialize
          self.fsevent = FSEvent.new
          self._broadcast_tail = Hash.new
        end

        def bind!

          params = Staticme.params

          Staticme.on(:fs_changed) do
            Staticme.broadcast(:event => 'fs_change')
          end.on(:staticme_terminated) do
            self.stop!
          end

          fsevent.watch params[:path] do |dirs|
            signature = get_signature(dirs)
            next if already_broadcasted?(signature)
            tail_broadcast(signature)
            Staticme.logger.info 'FS change, publishing the event.'
            Staticme.emit(:fs_changed, dirs)
          end

          Thread.abort_on_exception = true

          Thread.new do
            fsevent.run
          end

        end 

        def stop!
          fsevent.stop
        end

        protected

        def get_signature(params)
          Digest::MD5.hexdigest(params.to_s)
        end

        def already_broadcasted?(signature)
          !self._broadcast_tail[signature].nil?
        end

        def tail_broadcast(signature)
          self._broadcast_tail[signature] = true
          # fsevent triggers 2 events in a row
          # just a simple filtering
          EM.add_timer 1 do
            self._broadcast_tail.delete(signature)
          end
        end

      end

    end

  end

end
