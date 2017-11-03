class SettingsController < ApplicationController

  before_action :authenticate_user!

  before_action :set_header

  def my_settings
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => true}
                        ]
    if params[:user].present?
      if current_user.update_attributes(user_params)
        I18n.locale = session[:lang] = params[:user][:language].downcase.to_sym if params[:user][:language].present?
        flash[:notice] = I18n.t("general.profile_updated_successfully")
        redirect_to root_path
      else
        flash[:notice] = I18n.t("general.email_has_been_taken")
        render 'my_settings'
      end
    end
  end
  
  def more_options
    @user = @current_brand.users.find(params[:object_id])
    common_user_back_path(@user)
    common_nav_bar_path
  end

  def soft_delete
    if params[:action_type] == "delete"
      object = @current_brand.users.find(params[:object_id])
      if object.present?
        object.update_attributes!(is_deleted: true)

        flash.keep[:notice] = t('general.successfully_deleted')
        if object.executive?
          redirect_to executives_path
        elsif object.director?
          redirect_to directors_path
        elsif object.dentist?
          redirect_to dentists_path
        else  
          redirect_to root_path
        end
      else
        redirect_to root_path
      end
    end
  end

  def remove_user_data
    common_nav_bar_path
    if params[:object_id].present?
      @user = @current_brand.users.find(params[:object_id])
      @back_path = more_options_settings_path("User",@user, :open_card => true)
    end 
  end

  private

  def common_user_back_path(user)
    @user = user
    if @user.executive?
      @back_path = executive_path(@user)
    elsif @user.director?
      @back_path = director_path(@user)
    elsif @user.dentist?
      @back_path = dentist_path(@user)
    else
      @back_path = executive_path(@user)
    end
  end

  def common_nav_bar_path
    if current_user.executive?
      @nav_header_menus = [
                            {:href => desktop_executives_path, :label => t("nav_header.executive_desktop"), :arrowBack => false},
                            {:href => user_register_executives_path, :label => t("nav_header.user_register"), :arrowBack => true}
                          ]
    elsif current_user.director?
      @nav_header_menus = [
                            {:href => desktop_directors_path, :label => t("nav_header.director_desktop"), :arrowBack => false},
                            {:href => user_register_directors_path, :label => t("nav_header.user_register"), :arrowBack => true}
                          ]
    elsif current_user.dentist?
      @nav_header_menus = [
                            {:href => desktop_dentists_path, :label => t("nav_header.dentist_desktop"), :arrowBack => true}
                          ]
    end
  end

  def set_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.start"), :arrowBack => true}
                        ]
  end
  
  def user_params
    params.require(:user).permit(:email, :password, :linkedin_url, :facebook_url, :twitter_url, :address, :post_number, :city, :phone_number, :language, working_areas:[])
  end
end
