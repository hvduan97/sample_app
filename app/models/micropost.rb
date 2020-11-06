class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  scope :new_feed, ->(id){where("user_id IN (?)", id)}
  has_one_attached :image
  validates :content, presence: true,
    length: {maximum: Settings.max_content_micropost}
  validates :image, content_type: {in: %i(gif png jpg jpeg),
                                   message: I18n.t("models.micropost.content")},
                    size: {less_than: Settings.size_image_micropost.megabytes,
                           message: I18n.t("models.micropost.size_image")}
  def display_image
    image.variant(resize_to_limit: [Settings.resize_limit_image,
                                    Settings.resize_limit_image])
  end
end
