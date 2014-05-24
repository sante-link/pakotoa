class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def medispo
    @user = User.find_for_medispo_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect(@user, :event => :authentication) #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Médispo") if is_navigational_format?
    else
      session["devise.medispo_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def after_omniauth_failure_path_for(resource)
    root_path
  end
end
