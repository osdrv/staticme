require 'rack'
require 'rack/staticme_urlmap'

module Rack

  class StaticmeBuilder < Builder

    private

    def generate_map(default_app, mapping)
      mapped = default_app ? {'/' => default_app} : {}
      mapping.each { |r,b| mapped[r] = self.class.new(default_app, &b) }
      StaticmeURLMap.new(mapped)
    end

  end

end