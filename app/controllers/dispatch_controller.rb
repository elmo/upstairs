class DispatchController < ApplicationController

   def redirect
     redirect_to ShortUrl.find_by_token(params[:id]).url
   end

end
