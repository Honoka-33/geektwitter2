class SearchesController < ApplicationController
before_action :authenticate_user!
    def index
            @tweets = Tweet.all
                if params[:tag_ids]
                    @tweets = []
                    params[:tag_ids].each do |key, value|      
                        @tweets += Tag.find_by(name: key).tweets if value == "1"
                    end
                    @tweets.uniq!
                end
                @tweets = Kaminari.paginate_array(@tweets).page(params[:page]).per(3)
            if params[:tag]
                Tag.create(name: params[:tag])
            end

            search = params[:search]
            @tweets = Tweet.joins(:user).where("body LIKE ?", "%#{search}%") if params[:search].present?
            @tweets = @tweets.page(params[:page]).per(5)
    end
end
