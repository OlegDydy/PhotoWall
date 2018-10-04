class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
    
  def default_url_options
    { locale: I18n.locale }
  end

  def after_sign_in_path_for(resource)
    if (resource.instance_of? AdminUser)
      admin_dashboard_url
    else
      root_url
    end
  end

end
