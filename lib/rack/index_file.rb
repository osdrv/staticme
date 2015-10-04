require 'rack/file'

module Rack
  class IndexFile < File

    F = ::File

    def initialize(root, headers={}, default_mime = 'text/plain')
      @path = root
    end

    def _call(env)
      unless ALLOWED_VERBS.include? env[REQUEST_METHOD]
        return fail(405, "Method Not Allowed", {'Allow' => ALLOW_HEADER})
      end

      available = begin
        F.file?(@path) && F.readable?(@path)
      rescue SystemCallError
        false
      end

      if available
        serving(env)
      else
        fail(404, "File not found: #{path_info}")
      end
    end
  end
end

