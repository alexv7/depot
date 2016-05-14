class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_action :authorize
  protect_from_forgery with: :exception

  protected

  # def authorize
  #   unless User.find_by_id(session[:user_id]) or User.count.zero?
  #     redirect_to login_url, :notice => "Please log in"
  #   end
  #   if User.count.zero?
  #     redirect_to new_user_path, :notice => "Please create a user"
  #   end
  # end

  def authorize
    respond_to do |format|
      format.html do   #request.format == Mime::HTML
        unless User.find_by(id: session[:user_id]) or User.count.zero?
          redirect_to login_url, notice: "Please log in"
        end
        if User.count.zero?
          redirect_to new_user_path, :notice => "Please create a user"
        end
      end
      format.any do
        authenticate_or_request_with_http_basic do |username, password|
          user = User.find_by_name(username)
          user and user.authenticate(password)
        end
      end
    end
  end

end
