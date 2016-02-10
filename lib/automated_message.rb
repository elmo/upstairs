class AutomatedMessage
 attr_accessor :messageable

 def initialize(messageable)
   @messageable = messageable
 end

 def deliver
   case messageable.class.to_s
   when 'Comment'
      case messageable.sending_context
      when 'Manager'
        messageable.commentable.notifiable_users(except: messageable.user).each do |user|
          body = "There is a new comment"
	  url = "http://www.google.com"
          send_text_message(user: user, body: body, url: url)
	end
      end
   end
 end


 def send_text_message(user:, body:, url: )
   TwilioMessage.new(to: user.phone, body: body, url: url).deliver if user.receives_text_messages?
 end

end
