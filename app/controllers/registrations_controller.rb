class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    super
  end

  def create
    super
  end

  def update
     account_update_params = devise_parameter_sanitizer.sanitize(:user_update)
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
      account_update_params.delete("current_password")
    end
    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def configure_permitted_parameters
     registration_params = [:email, :password, :password_confirmation, :username, :phone,:avatar, :use_my_username, :ok_to_send_text_messages]
     if params[:action] == 'update'
       devise_parameter_sanitizer.for(:user_update) { |u| u.permit(registration_params << :current_password) }
     elsif params[:action] == 'create'
       devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(registration_params) }
     end
  end

  protected

  def after_sign_in_path_for(resource)
    user_home_path
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :current_password, :password_confirmation, :username, :phone, :avatar, :use_my_username, :ok_to_send_text_messages)
  end

end
