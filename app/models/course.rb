class Course < ApplicationRecord
  # validation
  validates :title, presence: { message: "Title can't be blank." }, uniqueness: 
  { message: ->(object, data) do
    "Title #{data[:value]} is already taken."
  end 
  }

# query
scope :by_status_and_type, -> (sort) { where(status: 'published', sort: sort) }

# enum
enum :status, [:draft, :published]
enum :sort, [:playback, :live]

# relationship
belongs_to :category, foreign_key: "category_id"
belongs_to :speaker, foreign_key: "speaker_id"
has_one_attached :image
has_rich_text :body

# trigger
after_validation :set_slug, only: [:create, :update]
  
def format_number(number)
  num_groups = number.to_s.chars.to_a.reverse.each_slice(3)
  num_groups.map(&:join).join(',').reverse
end

private
  def set_slug
    self.slug = title.to_s.parameterize
  end
end
