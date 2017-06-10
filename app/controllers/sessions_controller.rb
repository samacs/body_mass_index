class SessionsController < ApplicationController
  before_action :require_no_user, only: %i[new create]
  before_action :require_user, only: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(email: session_params[:email])
    if @user.present? && @user.authenticate(session_params[:password])
      login(@user)
      redirect_to_previous
    else
      if @user.present?
        flash.now[:error] = I18n.t('views.sessions.create.error.wrong_password')
      else
        @user = User.new
        flash.now[:error] = I18n.t('views.sessions.create.error.user_not_found')
      end
      render :new
    end
  end

  def destroy
    logout if logged_in?
    redirect_to_previous
  end

  private

  def session_params
    params.require(:user).permit(:email, :password)
  end
end
