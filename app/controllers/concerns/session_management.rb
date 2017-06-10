module SessionManagement
  extend ActiveSupport::Concern

  include SessionsHelper

  included do
    helper_method :current_user, :logged_in?
  end
end
