class TwilioMessage

  FROM_NUMBER = '+16179368426'

  def initialize(to, body, url = nil)
    to.strip
    to = "1" + to if to.size == 10
    to = "+" + to if to.size == 11
    client = Twilio::REST::Client.new
    if url.blank?
      client.messages.create(from: FROM_NUMBER, to: to, body: body)
    else
      client.messages.create(from: FROM_NUMBER, to: to, body: body, media_url: url)
    end
  end

end
