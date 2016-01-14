class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_filter :authenticate
  protected
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == (Rails.env.development? ? ENV['USERNAME_DEV'] : ENV['USERNAME_PRO'])&& password == (Rails.env.development? ? ENV['PASSWORD_DEV'] : ENV['PASSWORD_PRO'])
      # reset_session
    end
  end

  def errors(message)
    @status = "Failure"
    @error = []
    @error<< "#{message}"
  end
  helper_method :errors, :authenticate
end
