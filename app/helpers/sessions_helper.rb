module SessionsHelper
  def current_header_session
    if authenticated?
      render :partial => 'layouts/session'
    else
      render :partial => 'layouts/login'
    end
  end
end
