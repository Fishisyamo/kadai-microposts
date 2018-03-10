module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: sessions[:user_id])
  end

  def logged_in?
    !!current_user
  end
end