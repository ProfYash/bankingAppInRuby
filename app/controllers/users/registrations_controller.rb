# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin_user!, only: [:new, :create, :allUsers]
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_no_authentication, except: [:new, :create, :allUsers]

  def new
    super
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :is_admin, :full_name])
  end

  def create
    if current_user.is_admin
      puts "?????create???if??????????"
      puts current_user.inspect
      super
    else
      redirect_to root_path, notice: "Only admins can create new users."
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:fullname, :email, :password, :password_confirmation, :is_admin, :total_balance)
  end

  def authenticate_admin_user!
    puts current_user.inspect
    if !current_user.is_admin
      puts "?????authenticate_admin_user???if??????????"
      redirect_to root_path
    end
  end

  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
