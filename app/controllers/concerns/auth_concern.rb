# frozen_string_literal: true

module AuthConcern
  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session.delete(:user_id)
    session.clear
  end

  def signed_in?
    !current_user.guest?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) || Guest.new
  end

  def authenticate_admin!
    redirect_to root_path unless current_user.admin?
  end

  def sign_in_as(name)
    user = users(name)
    post session_url, params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
    user
  end
end
