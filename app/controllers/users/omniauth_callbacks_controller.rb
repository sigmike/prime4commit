class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # render text: "#{request.env["omniauth.auth"].to_json}"
    info = request.env["omniauth.auth"]["info"]
    @user = User.enabled.find_by :nickname => info["nickname"]
    if @user.nil? and info["verified_emails"].any?
      @user = User.enabled.find_by :email => info["verified_emails"]
    end
    unless @user
      if info['primary_email']
        @user = User.new(
          :email => info['primary_email'],
          :nickname => info['nickname']
        )
        @user.confirm
        @user.save!
      else
        set_flash_message(:error, :failure, kind: 'GitHub', reason: 'your primary email address should be verified.')
        redirect_to new_user_session_path and return
      end
    end

    @user.name ||= info['name']
    @user.image ||= info['image']
    @user.save

    Collaborator.where(login: @user.nickname, user_id: nil).each do |collaborator|
      collaborator.update(user: @user)
    end
    
    sign_in(@user)
    redirect_to request.env["omniauth.origin"].presence || after_sign_in_path_for(@user)
    set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
  end
end
