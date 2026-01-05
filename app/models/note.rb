class Note < ApplicationRecord
  belongs_to :user
  has_many :note_shares, dependent: :destroy
  has_many :shared_users, through: :note_shares, source: :user

  validates :title, presence: true
  validates :description, presence: true

  scope :favorites, -> { where(favorite: true) }
end
