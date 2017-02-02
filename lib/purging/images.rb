require "purging/images/version"

module Purging
  module Images
    class Cache
      include HTTParty
      base_uri 'https://api.imgix.com/v2'.freeze

      class << self
        def call(url)
          new(url).call
        end
      end

      def initialize(url, api_key)
        @options = { body: { url: URI.parse(URI.encode(url.strip)) }, basic_auth: { username: api_key, password: '' } }
      end

      def call
        purge = self.class.post('/image/purger'.freeze, @options)
        purge.success?
      rescue Errno::ECONNRESET, SocketError
        { 'status' => 'failed' }
      end
    end
  end
end
