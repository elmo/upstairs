class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    super
  end

  def create
    build_resource(sign_up_params)
    if session[:invitation_code]
      @invitation = Invitation.find_by_token(session[:invitation_code])
      resource.invitation = @invitation
    end
    # resource.invitation_link = session[:invitation_link]
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  def update
    account_update_params = devise_parameter_sanitizer.sanitize(:user_update)
    if account_update_params[:password].blank?
      account_update_params.delete('password')
      account_update_params.delete('password_confirmation')
      account_update_params.delete('current_password')
    end
    @user = User.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      sign_in @user, bypass: true
      redirect_to after_update_path_for(@user)
    else
      render 'edit'
    end
  end

  def configure_permitted_parameters
    registration_params = [:email, :password, :password_confirmation, :username, :phone, :avatar, :use_my_username, :ok_to_send_text_messages]
    if params[:action] == 'update'
      devise_parameter_sanitizer.for(:user_update) { |u| u.permit(registration_params << :current_password) }
    elsif params[:action] == 'create'
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(registration_params) }
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if session[:invitation_link].present?
      building = Building.where(invitation_link: session[:invitation_link]).first
      resource.join(building) if building.present?
      session[:invitation_code] = nil
      session[:invitation_link] = nil
      building_path(building)
    else
      home_path
    end
  end

  def after_update_path_for(_resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :current_password, :password_confirmation, :username, :phone, :avatar, :use_my_username, :ok_to_send_text_messages, :invitation_id)
  end
end
