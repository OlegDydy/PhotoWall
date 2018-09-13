class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    root_url
  end

  # def after_sign_out_path_for(esource_ore_scope)
  #   reqest.referrer
  # end
end
