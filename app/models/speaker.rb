class Speaker < ApplicationRecord

  has_rich_text :body 
  
  validates :full_name, presence: { message: "Spekaer name can't be blank." }, uniqueness: 
  { message: ->(object, data) do
      "Speaker with name #{data[:value]} is already taken."
    end 
  }
  validates :title, presence: { message: "Title can't be blank." }
  validates :body, presence: { message: "Description can't be blank." }
end
