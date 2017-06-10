module RedirectionManagement
  extend ActiveSupport::Concern

  included do
    after_action :save_current_url
  end

  module ClassMethods
    def dont_save_return_url(options = {})
      skip_after_action :save_current_url, options
    end
  end

  protected

  def redirect_to_previous(options = {})
    url = if session[:previous_url] &&
             session[:previous_url] != request.original_url
            session[:previous_url]
          else
            root_path
          end

    redirect_to url, options
  end

  def not_found
    render file: Rails.root.join('public', '404.html'), layout: false
  end

  private

  def save_current_url
    return unless request.get?
    session[:previous_url] = request.original_url
  end
end
