require 'uri'

class UrlsController < ApplicationController
    def index
        @record = record_for_short_url?(params['short_url'])
         @json_output = nil
        if @record
            @json_output = {'record': @record, 'users': @record.users}
        else
            @json_output = @record 
        end
        render :json => @json_output
    end

    def create
        @full_url = url_params['full_url'];
        if vaild_url?(@full_url)
            @record = record_for_full_url?(@full_url)
            if !@record
                @url = Url.new(url_params)
                @url.save
                @url.short_url = create_short_url_path(@url.id)
                @url.save

                create_short_url(@url)
                render 'home/index'
            else
                create_short_url(@record)
                render 'home/index'
            end
        else
            if @full_url.length > 0
            params['error'] =  @full_url + ' is an invalid URL'
        else
            params['error'] = 'No URL entered'
        end
            render 'home/index'
        end
    end

    private

    def create_short_url(record) 
        @request = request.url
#        #this is a hack to remove the urls at the end of the url
        if @request.length > 4
            if @request[-4,4] == 'urls'
                @request = @request[0, @request.length - 4]
            end
        end
        params['short_url'] = @request + record.short_url
        params['full_url'] = record.full_url
    end

    @@alphabet = "23456789bcdfghjkmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ-_"
    @@base = @@alphabet.length

    def create_short_url_path(urlID)
        @short_url = ""
        while urlID > 0
            @short_url = @@alphabet[urlID % @@base] + @short_url
            urlID = urlID / @@base
        end
        return @short_url
    end

    def convert_back_to_long_url(short_url)
        @urlID = 0
        for i in 0 .. short_url.length - 1
            @urlID = @urlID * @@base + @@alphabet.index(short_url[i])
        end
        return @urlID
    end
    
    def url_params
        params.require(:url).permit(:full_url)
    end
end
