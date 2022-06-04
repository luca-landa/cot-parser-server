# frozen_string_literal: true

require 'net/http'
require 'mini_cache'

class HttpClient
  def fetch(url:)
    cache_store.get_or_set(url) do
      response = Net::HTTP.get_response(URI(url))
      return unless response.is_a? Net::HTTPOK

      response.body
    end
  end

  private

  def cache_store
    @cache_store ||= MiniCache::Store.new
  end
end
