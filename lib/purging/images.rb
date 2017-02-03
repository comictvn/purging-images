require "purging/images/version"

module Purging
  module Images
    class Cache
      include HTTParty
      base_uri 'https://api.imgix.com/v2'.freeze

      def initialize(options)
        url = options[:url]
        api_key = options[:api_key]
        @options = { body: { url: url }, basic_auth: { username: api_key, password: '' } }
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
