class Photo < ApplicationRecord
  include PostsUploader::Attachment(:image)
  belongs_to :post

  validates_presence_of :image
end