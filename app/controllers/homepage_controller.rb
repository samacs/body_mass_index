class HomepageController < ApplicationController
  def index
    @user = User.new unless logged_in?
  end
end
