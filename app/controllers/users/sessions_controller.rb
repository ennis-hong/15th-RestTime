# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    # before_action :configure_permitted_parameters, if: :devise_controller?

    # GET /resource/sign_in

    # POST /resource/sign_in

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_permitted_parameters
    #   added_attrs = %i[email encrypted_password password_confirmation remember_me]
    #   devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
    #   devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    #   devise_parameter_sanitizer.permit(:sign_in, keys: added_attrs)
    # end
  end
end
