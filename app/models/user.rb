class User < ApplicationRecord

  enum :role, [:member, :admin]

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  validates_presence_of :first_name, presence: true, :message => "First name can't be blank"
  validates_presence_of :last_name, presence: true, :message => "Last name can't be blank"
  validates_presence_of :phone_number, presence: true, :message => "Phone number can't be blank."

  def self.full_name(current_user)
    current_user.first_name + " " + current_user.last_name
  end

end
