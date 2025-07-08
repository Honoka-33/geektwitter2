class Tweet < ApplicationRecord
  belongs_to :user 
  has_one_attached :image

    has_many :tweet_tag_relations, dependent: :destroy
    has_many :tags, through: :tweet_tag_relations, dependent: :destroy

    has_many :tweet_hashtags, dependent: :destroy
    has_many :hashtags, through: :tweet_hashtags

    after_create_commit :save_hashtags
    after_update_commit :save_hashtags 

    #tweetsテーブルから中間テーブルに対する関連付け
  has_many :tweet_tag_relations, dependent: :destroy
  #tweetsテーブルから中間テーブルを介してTagsテーブルへの関連付け
  has_many :tags, through: :tweet_tag_relations, dependent: :destroy

  private
  def save_hashtags
    Rails.logger.debug "--- [save_hashtags] メソッドが呼び出されました。Tweet ID: #{self.id}, Body: #{self.body.inspect}"

    # 1. 本文からハッシュタグを抽出
    # bodyカラムを使用しているとのことなので、self.contentではなくself.bodyを使います
    extracted_hashtags = self.body.scan(/[#＃]([A-Za-z0-9_]+)/).map do |match|
      match[0].delete('#').delete('＃').downcase # matchは配列の配列なのでmatch[0]で文字列を取得
    end
    Rails.logger.debug "--- [save_hashtags] 抽出されたハッシュタグ: #{extracted_hashtags.inspect}"

    # 抽出されたハッシュタグがない場合はここで処理を終了
    return if extracted_hashtags.empty?

    # 2. 既存のハッシュタグ関連付けをクリア（更新時のために）
    # self.persisted? はレコードがデータベースに既に保存されているかどうかを判断します。
    # self.hashtags.clear は、既存の TweetHashtag レコードを削除します。
    if self.persisted? && self.hashtags.any?
      Rails.logger.debug "--- [save_hashtags] 既存のハッシュタグ関連付けをクリアします。"
      self.hashtags.clear
    end

    # 3. 各ハッシュタグを処理（作成または検索し、関連付け）
    extracted_hashtags.uniq.each do |tag_name|
      Rails.logger.debug "--- [save_hashtags] 処理中のタグ名: '#{tag_name}'"
      hashtag = Hashtag.find_or_create_by(name: tag_name) do |tag|
        Rails.logger.debug "--- [save_hashtags] 新規ハッシュタグを作成: #{tag_name}"
      end
      # find_or_create_by のブロックは、新規作成されるときにのみ実行されます。

      if hashtag.persisted? # ハッシュタグがDBに保存されたか確認
        # unless self.hashtags.include?(hashtag) は、重複して関連付けないための安全策です。
        unless self.hashtags.include?(hashtag)
          self.hashtags << hashtag
          Rails.logger.debug "--- [save_hashtags] ツイート #{self.id} にハッシュタグ #{hashtag.name} (ID: #{hashtag.id}) を関連付けました。"
        else
          Rails.logger.debug "--- [save_hashtags] ハッシュタグ #{hashtag.name} は既にツイート #{self.id} に関連付けられています。"
        end
      else
        Rails.logger.error "--- [save_hashtags] ハッシュタグ #{tag_name} の保存に失敗しました。エラー: #{hashtag.errors.full_messages.to_sentence}"
      end
    end
    Rails.logger.debug "--- [save_hashtags] メソッドの処理が完了しました。"
  end
end
