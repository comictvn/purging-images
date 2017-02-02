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
        @options = { body: { url: url }, basic_auth: { username: api_key, password: '' } }
      end

      def call
        begin
          purge = self.class.post('/image/purger'.freeze, @options)
          purge.success?
        rescue Exception => e
          p e
        end
      end
    end
  end
end
