class EmailInterceptor
  def self.delivering_email(message)
    message.to = ['elliott.blatt@gmail.com']
  end
end
