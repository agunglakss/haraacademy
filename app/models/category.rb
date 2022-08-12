class Category < ApplicationRecord
  validates :name, presence: { message: "Category name can't be blank." }, uniqueness: 
  { message: ->(object, data) do
      "Category #{data[:value]} is already taken."
    end 
  }
end
