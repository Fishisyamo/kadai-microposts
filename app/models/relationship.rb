class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :follow
  
  validates :user_id,   presence: true
  validates :follow_id, presence: true
end