class ShortUrl < ActiveRecord::Base
  after_create :save_token

  def self.for(url)
    Rails.application.routes.url_helpers.dispatch_url(
      (ShortUrl.where(url: url).first || ShortUrl.create(url: url)).token
    )
  end

  private

  def save_token
    while token = SecureRandom.hex(5)
      next if ShortUrl.where(token: token).exists?
      update_attributes(token: token)
      return
    end
  end
end
