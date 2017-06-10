class ApplicationController < ActionController::Base
  include SessionManagement
  include RedirectionManagement

  protect_from_forgery with: :exception

  add_flash_types :success, :error
end
