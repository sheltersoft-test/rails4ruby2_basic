class DesktopController < ApplicationController

  before_filter :authenticate_user!
  
  def index
    if current_user
      if current_user.executive?
        redirect_to desktop_executives_path
      elsif current_user.director?
        redirect_to desktop_directors_path
      elsif current_user.dentist?
        redirect_to desktop_dentists_path
      else
        reset_session
        redirect_to sign_in_path
      end
    else
      redirect_to sign_in_path
    end
  end
end