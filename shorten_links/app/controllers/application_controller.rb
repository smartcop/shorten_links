class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	def record_for_short_url?(short_url)
   		@record = Url.where(short_url: short_url).take
    	return @record
    rescue ActiveRecord::RecordNotFound
	end

	def record_for_full_url?(full_url)
   		@record = Url.where(full_url: full_url).take
    	return @record
    rescue ActiveRecord::RecordNotFound
	end

	def vaild_url?(url)
		uri = URI.parse(url)
 	 	%w( http https ).include?(uri.scheme)
	rescue URI::BadURIError
	rescue URI::InvalidURIError
	end
end
