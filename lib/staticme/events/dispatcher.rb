module Staticme

  module Events

    module Dispatcher

      def self.included(base)
        base.class_eval do

          attr_accessor :events

          def on(event_name, &event_handler)
            ((self.events ||= {})[event_name.to_sym] ||= []).push(event_handler)
            self
          end

          def emit(event_name, *args)
            ((self.events ||= {})[event_name.to_sym]).tap do |event_pool|
              return if event_pool.nil?
              event_pool.map do |handler|
                handler.call(*args)
              end
            end
            self
          end

        end
      end

    end

  end

end
