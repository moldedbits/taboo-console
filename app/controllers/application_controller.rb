class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: (Rails.env.development? ? ENV['USERNAME_DEV'] : ENV['USERNAME_PRO']),password: (Rails.env.development? ? ENV['PASSWORD_DEV'] : ENV['PASSWORD_PRO'])
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def errors(message)
    @status = "Failure"
    @error = []
    @error<< "#{message}"
  end
  helper_method :errors
end
