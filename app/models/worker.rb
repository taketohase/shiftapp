class Worker < ApplicationRecord
  has_secure_password

  has_many :owner_workers, dependent: :destroy
  has_many :owners, through: :owner_workers

  has_many :entries, dependent: :destroy
  has_many :requests, dependent: :destroy

  validates :name, {presence: true}
  validates :email, {presence:true, uniqueness: true}
  validates :userid, {presence: true,
                      uniqueness: true,
                      length: {minimum: 4, maximum: 16}}
end
