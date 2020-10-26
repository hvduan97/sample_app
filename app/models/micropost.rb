class Micropost < ApplicationRecord
  belongs_to :user
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  validates :content, presence: true,
    length: {maximum: Settings.max_content_micropost}
  validates :image, content_type: {in: %i(gif png jpg jpeg),
                                   message: I18n.t("models.micropost.mess_image")},
                    size: {less_than: Settings.size_image_micropost.megabytes,
                           message: I18n.t("models.micropost.message_size_image")}
  def display_image
    image.variant resize_to_limit: [Settings.resize_limit_image,
                                    Settings.resize_limit_image]
  end
end
