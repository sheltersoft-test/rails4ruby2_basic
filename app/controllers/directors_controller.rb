class DirectorsController < ApplicationController

  before_action :authenticate_executive!, except: [:desktop]
  before_action :authenticate_director!, only: [:desktop]

	before_action :set_director, only: [:show, :edit, :update, :destroy]

  # GET /directors
  # GET /directors.json
  def index
    @nav_header_menus = [
                          {:href => desktop_executives_path, :label => t("nav_header.executive_desktop"), :arrowBack => false},
                          {:href => user_register_executives_path, :label => t("nav_header.user_register"), :arrowBack => true}
                        ]
    @back_to_top = true
    @directors = fetch_users.page(page).per(first_limit)
  end

  def user_filter
    @directors = fetch_users.page(page).per(first_limit)
  end

  def next_users
    @directors = fetch_users.page(page).per(limit)
    render layout: false
  end  

  # GET /directors/1
  # GET /directors/1.json
  def show
    common_nav_header_menu
  end

  # GET /directors/new
  def new
    common_nav_header_menu
    @step = 1
    @director = @current_brand.users.new
    @secure_pass = SecureRandom.hex(6)
  end

  # POST /directors
  # POST /directors.json
  def create
    common_nav_header_menu
    @director = @current_brand.users.new(director_params)
    @secure_pass = SecureRandom.hex(6)
    @step = 1
    if @director.save
      if params[:role].present?
        UserRole.create(:role => params[:role].to_i, :user => @director)
      end
      step = params[:proceed_next] ? 2 : 1
      redirect_to edit_director_path(@director, :step => step)
    else
      render 'new'
    end
  end

  # GET /directors/1/edit
  def edit
    common_nav_header_menu
    @step = params[:step] || 1
  end

  # PATCH/PUT /directors/1
  # PATCH/PUT /directors/1.json
  def update
    common_nav_header_menu
    if params[:open_card] == "true"
      flash.keep[:notice] = t("general.information_saved")
    end

    if params[:step].to_i == 2
      set_other_languages @director
      check_user_skills @director
      set_other_job_role @director
    end
    
    if !params[:user].present?
      @director.update_attributes(:registered => true) unless @director.registered
      flash.keep[:notice] = t("director.director_updated")
      redirect_to directors_path
    elsif @director.update(director_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      redirect_to edit_director_path(@director, :step => step, :open_card => open_card_param)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  # DELETE /directors/1
  # DELETE /directors/1.json
  def destroy
    @director.destroy
    respond_to do |format|
      format.html { redirect_to directors_url, notice: t("director.director_destroyed") }
      format.json { head :no_content }
    end
  end


  def user_register
  	user_register_header
  end


  def user_register_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.executive_desktop"), :arrowBack => true}
                        ]
  end


  def common_nav_header_menu
    @nav_header_menus = [
                          {:href => desktop_executives_path, :label => t("nav_header.executive_desktop"), :arrowBack => false},
                          {:href => user_register_executives_path, :label => t("nav_header.user_register"), :arrowBack => false},
                          {:href => directors_path, :label => t("nav_header.directors"), :arrowBack => true}
                        ]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_director
    @director = @current_brand.users.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def director_params
    params.require(:user).permit(:brand_id, :email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :ssn, :address, :phone_number, :post_number, :city, :personal_email, :gender, :contract_start_date, :contract_end_date, :contract_type, :contract_probation, :creator_id, :updater_id,
                                 :job_role, :other_job_role, :other_business_degrees, :introduction, resources_attributes: [ :id, :media, :resource_type_id, :resource_spec_id ], languages:[])
  end

  private

  def fetch_users
    users = @current_brand.users.directors
    
    if params[:search].present?      
      search = session[:director_search] = params[:search]
    else
      if params[:role].present?
        search = session[:director_search] = nil
      else
        search = session[:director_search] if session[:director_search].present?
      end
    end
    if search.present?
      session[:director_search] = search
      users = users.where('first_name LIKE ? or last_name LIKE ? or city LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    end
    users.order('id DESC').uniq
  end

  def set_other_job_role user
    if params[:user][:job_role].present?
      if params[:other_job_role].present?
        params[:user][:job_role] = ''
        user.other_job_role = params[:other_job_role]
      else
        user_job_role = user.other_job_role
        params[:user][:other_job_role] = user_job_role.present? ? user_job_role : ""
      end
    else
      user.job_role = ""
    end
  end
end
