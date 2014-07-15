module Staticme

  module Events

    class Dispatcher

      def initialize
        @events = Hash.new
      end

      def on(event_name, &event_handler)
        (@events[event_name.to_sym] ||= []).push(event_handler)
        self
      end

      def emit(event_name, *args)
        (@events[event_name.to_sym]).tap do |event_pool|
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
