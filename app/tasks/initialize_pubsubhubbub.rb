require "rack-superfeedr"
require "date"
require "ostruct"
require "json"

require_relative "../repositories/feed_repository"
require_relative "../repositories/story_repository"
require_relative "../repositories/user_repository"

class Stringer < Sinatra::Base

	begin

		ENV["PUBSUBHUBBUB_HOST"] = "localhost"
		ENV["PUBSUBHUBBUB_USERNAME"] = "demo"
	   	ENV["PUBSUBHUBBUB_PASSWORD"] = "demo"

		if settings.host
			ENV["PUBSUBHUBBUB_HOST"] = settings.host
	   	end

		pubsubhubbub_config =  {
	      :host     => ENV["PUBSUBHUBBUB_HOST"],
	      :login    => ENV["PUBSUBHUBBUB_USERNAME"],
	      :password => ENV["PUBSUBHUBBUB_PASSWORD"],
	      :format => "json", 
	      :async => false
	    }

		use Rack::Superfeedr, pubsubhubbub_config do |pubsubhubbub|
		   	set :pubsubhubbub, pubsubhubbub

		   	pubsubhubbub.on_notification do |notification|
	    		href = notification["standardLinks"]["self"][0]["href"]

	    		feed = FeedRepository.fetch_by_url(href)

	    		unless feed.nil?

	    			notification["items"].each do |e|

	    				old_story = StoryRepository.fetch_by_url(e["permalinkUrl"])

	    				if old_story.nil?

				    		story = OpenStruct.new e
							story.published = Time.at(e["published"].to_i).to_datetime.to_s
							story.url = e["permalinkUrl"]

							story = StoryRepository.add(story, feed)

							settings.stories << story.to_json
						end
					end
				end
	    	end
		end

	rescue Exception => msg  
		puts msg
	end	
end