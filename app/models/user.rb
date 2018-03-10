class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password

  # マイクロポスト
  has_many :microposts
  # リレーションシップ
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship',
                                      foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  # お気に入り
  has_many :favorites
  has_many :favoring, through: :favorites, source: :micropost

  # メソッド

    # ユーザをフォロー
    def follow(other_user)
      unless self == other_user
        self.relationships.find_or_create_by(follow_id: other_user.id)
      end
    end
  
    # ユーザのフォローを外す
    def unfollow(other_user)
      relationship = self.relationships.find_by(follow_id: other_user.id)
      relationship.destroy if relationship
    end
  
    # ユーザをフォローしているか確認
    def following?(other_user)
      self.followings.include?(other_user)
    end
  
    # フィード
    def feed_microposts
      Micropost.where(user_id: self.following_ids + [self.id])
    end
  
    # マイクロポストをお気に入り
    def favor(micropost)
      unless self.id == micropost.user_id
        self.favorites.find_or_create_by(micropost_id: micropost.id)
      end
    end
  
    # マイクロポストをお気に入りから外す
    def unfavor(micropost)
      favorite = self.favorites.find_by(micropost_id: micropost.id)
      favorite.destroy if favorite
    end
  
    # マイクロポストをお気に入りしているか確認
    def favoring?(micropost)
      self.favoring.include?(micropost)
    end
end