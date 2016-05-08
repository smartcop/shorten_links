class HomeController < ApplicationController
    def index
    	@short_url = params['path']
    	if @short_url
    		@record = (valid?(@short_url))
    		if @record.full_url
                @user_params = {'ip_address': request.remote_ip, 'user_agent': request.env["HTTP_USER_AGENT"]}
                @record.users.create(@user_params)
                @record.increment(:visits, by = 1)
                @record.save()
 		  		redirect_to @record.full_url
 		  	end
    	end
    end

    private 

    def valid?(short_url)
    	@record = Url.where(short_url: short_url).take
    	return @record

        rescue ActiveRecord::RecordNotFound
        return nil
    end
end
