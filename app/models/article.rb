class Article < ApplicationRecord
    include Visible
 

    has_many :comments, dependent: :destroy

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }

    def self.public_count
        where(status: 'public').count
  end

end
