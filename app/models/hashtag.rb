class Hashtag < ApplicationRecord
    has_many :tweet_hashtags, dependent: :destroy 
    has_many :tweets, through: :tweet_hashtags 
    
    validates :name, presence: true, uniqueness: { case_sensitive: false }, 
    format: { with: /\A[a-z0-9_]+\z/, message: "は半角英数字とアンダースコアのみ使用できます" } 
    # 必要に応じてnameのバリデーションを追加
end
