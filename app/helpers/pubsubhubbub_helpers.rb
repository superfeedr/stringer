require 'nokogiri'
require 'open-uri'

class PubSubHubbubHelper

	def self.get_hub(url)
		doc = Nokogiri::XML(open(url))
		rel_hub = doc.css("[rel='hub']")
        if rel_hub.length > 0
          rel_hub.map{|link|
            return link['href']
          }
        end
	end

end