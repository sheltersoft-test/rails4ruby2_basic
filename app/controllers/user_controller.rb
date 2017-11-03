class UserController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]

  def edit
    if params[:id]
      @user = @current_brand.users.find(params[:id]) if params[:id]
    else
      @user = current_user
    end
    if current_user.can_update_user? @user
      if @user.executive?
        @back_path = executives_path
      elsif @user.director?
        @back_path = directors_path
      elsif @user.dentist?
        @back_path = dentists_path
      else
        @back_path = executives_path
      end
    else
      redirect_to root_path
    end
  end

  def update_password
    if params[:id]
      @user = @current_brand.users.find(params[:id]) if params[:id]
    else
      @user = current_user
    end
    if current_user.can_update_user? @user
      if @user.executive?
        @back_path = executives_path
      elsif @user.director?
        @back_path = directors_path
      elsif @user.dentist?
        @back_path = dentists_path
      else
        @back_path = executives_path
      end
    end
    if @user.update_attributes(user_params)            
      flash[:notice] = I18n.t("general.password_updated_successfully")
      redirect_to @back_path
    else
      render "edit"
    end
  end

  def edit_profile    
  end
  
  def update_profile
    if current_user.update_attributes(edit_user_params)
      flash[:notice] = I18n.t("general.profile_updated_successfully")
      redirect_to edit_profile_path
    else
      render "edit_profile"
    end
  end

  def show
    @user = User.find params[:id]
    user_role = @user.user_role.role
    prepare_meta_tags title: @user.full_name, description: user_role, keywords: @user.full_name
  end

  def update_old_password
    @user = current_user
    if @user.valid_password? params[:old_password]
      if @user.update_attributes(:password => params[:new_password], :password_confirmation => params[:password_confirmation])
        sign_in(current_user, :bypass => true)
        flash[:notice] = I18n.t("general.password_updated_successfully");
        render :js => "window.location = '#{personal_settings_path}'"
      end
    else
      @user.errors[:invalid_current_password] << I18n.t("general.invalid_current_password");
      respond_to do |format|
        format.js { render :layout => false }
      end
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation)
  end

  def edit_user_params
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end
end
