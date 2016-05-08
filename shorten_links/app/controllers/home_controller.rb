class HomeController < ApplicationController
    def index
    	@short_url = params['path']
    	if @short_url
    		@record = record_for_short_url?(@short_url)
    		if @record && @record.full_url
                @user_params = {'ip_address': request.remote_ip, 'user_agent': request.env["HTTP_USER_AGENT"]}
                @record.users.create(@user_params)
                @record.increment(:visits, by = 1)
                @record.save()
 		  		redirect_to @record.full_url
 		  	end
    	end
    end
end
