class HashtagsController < ApplicationController
  #skip_before_action :authenticate_user!, only: [:show] # showアクションのみ認証をスキップ
  def show
    @hashtag = Hashtag.find(params[:id])
    #@hashtag = Hashtag.find_by!(name: params[:id].downcase) # idではなくnameで検索
    @tweets = @hashtag.tweets.includes(:user).order(created_at: :desc) # 関連するツイートを取得
  rescue ActiveRecord::RecordNotFound
    # ハッシュタグが見つからない場合の処理（例: 404エラーページへリダイレクト）
    redirect_to root_path, alert: "指定されたハッシュタグは見つかりませんでした。"
  end
end