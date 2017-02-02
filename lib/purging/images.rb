require "purging/images/version"

class Purging::Images
  include HTTParty
  API_KEY = ENV.fetch('IMGIX_API_KEY'.freeze)
  base_uri 'https://api.imgix.com/v2'.freeze

  class << self
    def call(url)
      new(url).call
    end
  end

  def initialize(url)
    @options = { body: { url: url }, basic_auth: { username: API_KEY, password: '' } }
  end

  def call
    purge = self.class.post('/image/purger'.freeze, @options)
    purge.success?
  rescue Errno::ECONNRESET, SocketError
    { 'status' => 'failed' }
  end
end
