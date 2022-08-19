class Video < ApplicationRecord

  # validation
  validates :subject, presence: { message: "Video title can't be blank." }
  validates :course_id, presence: { message: "Course title can't be blank." }
  validates :url_video, presence: { message: "URL video title can't be blank." }, uniqueness: 
  { message: ->(object, data) do
    "URL video #{data[:value]} is already taken."
  end 
  }

  belongs_to :course, foreign_key: "course_id"
end
