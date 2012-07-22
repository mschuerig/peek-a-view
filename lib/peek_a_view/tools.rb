require 'uri'

module PeekAView
  module Tools
    def self.view_from_uri(uri, options = { })
      if (prefix = options[:prefix])
        uri.sub(%r|^#{prefix}/?|, '')
      else
        URI.parse(uri).path
      end
    end
  end
end
