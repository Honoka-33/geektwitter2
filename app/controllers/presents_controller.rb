class PresentsController < ApplicationController
    def index
    end

    def new
        @present = Present.new
    end

    def show
        @present = Present.find_by(id: params[:id])
    end

    def create
        @present = Present.new(present_params)
        params[:present][:question] ? @present.question = params[:present][:question].join("") : false
    if @present.save
        flash[:notice] = "診断が完了しました"
        redirect_to present_path(@present.id)
    else
        redirect_to :action => "new"
    end
  end

private
    def present_params
        params.require(:present).permit(:id, question: [])
    end
end
