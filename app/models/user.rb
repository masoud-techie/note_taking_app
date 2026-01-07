class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :notes, dependent: :destroy

  has_many :note_shares, dependent: :destroy
  has_many :shared_notes, through: :note_shares, source: :note

  # app/models/user.rb
  validates :name, presence: true
  validates :last_name, presence: true
  before_save :capitalize_name

  def capitalize_name
    self.name = name.titleize if name.present?
  end

  def full_name
    "#{name} #{last_name}"
  end

  alias_attribute :name, :first_name

end
