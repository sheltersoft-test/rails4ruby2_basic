module Tolk
  class ApplicationController < ActionController::Base
    include Tolk::Pagination::Methods

    helper :all
    protect_from_forgery

    cattr_accessor :authenticator
    before_action :authenticate

    def authenticate
      if params[:controller] == "tolk/locales"
        @nav_header_menus = [
                            {:href => "executives/desktop", :label => t("nav_header.start"), :arrowBack => false},
                            {:href => "/translation_tool", :label => t("translation_tool.translation") , :arrowBack => true}
                          ]
      elsif params[:controller] == "tolk/searches"
        @nav_header_menus = [
                            {:href => "executives/desktop", :label => t("nav_header.start"), :arrowBack => false},
                            {:href => "/translation_tool/locales/fi", :label => t("translation_tool.translation") , :arrowBack => true}
                          ]
      end
#      self.authenticator.bind(self).call if self.authenticator && self.authenticator.respond_to?(:call)
      instance_exec(nil, &self.authenticator) if self.authenticator && self.authenticator.respond_to?(:instance_exec)
    end

    def ensure_no_primary_locale
      redirect_to tolk.locales_path if @locale.primary?
    end
  end
end
