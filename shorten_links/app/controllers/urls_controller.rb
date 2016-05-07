require 'uri'

class UrlsController < ApplicationController
    def show
        @url = Url.find(params[:id])
    end
    def new
        @url = Url.new
    end
    def create

        @url = Url.new(url_params)
        @full_url = url_params['full_url'];
        if valid?(@full_url)

            if !Url.exists?(full_url: @full_url)
                @url.save
                @url.short_url = create_short_url(@url.id)
                @url.save

                @request = request.url
                #this is a hack to remove the urls at the end of the url
                if @request.length > 4
                    if @request[-4,4] == 'urls'
                        @request = @request[0, @request.length - 4]
                    end
                end
                params['short_url'] = @request + @url.short_url
                @url.save
                render 'home/index'
                else
               	redirect_to url_params['full_url']
            end
            else
            render 'home/index'
        end
    end

    private

    @@alphabet = "23456789bcdfghjkmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ-_"
    @@base = @@alphabet.length

    def valid?(uri)
        !!URI.parse(uri)
        rescue URI::InvalidURIError
        false
    end

    def create_short_url(urlID)

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
