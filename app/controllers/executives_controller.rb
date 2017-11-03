class ExecutivesController < ApplicationController

  before_action :authenticate_executive!

	before_action :set_executive, only: [:show, :edit, :update, :destroy]

  # GET /executives
  # GET /executives.json
  def index
    @nav_header_menus = [
                          {:href => desktop_executives_path, :label => t("nav_header.executive_desktop"), :arrowBack => false},
                          {:href => user_register_executives_path, :label => t("nav_header.user_register"), :arrowBack => true}
                        ]
    @back_to_top = true
    @executives = fetch_users.page(page).per(first_limit)
  end

  def user_filter
    @executives = fetch_users.page(page).per(first_limit)
  end

  def next_users
    @executives = fetch_users.page(page).per(limit)
    render layout: false
  end  

  # GET /executives/1
  # GET /executives/1.json
  def show
    common_nav_header_menu
  end

  # GET /executives/new
  def new
    common_nav_header_menu
    @step = 1
    @executive = @current_brand.users.new
    @secure_pass = SecureRandom.hex(6)
  end

  # POST /executives
  # POST /executives.json
  def create
    common_nav_header_menu
    @executive = @current_brand.users.new(executive_params)
    @secure_pass = SecureRandom.hex(6)
    @step = 1
    if @executive.save
      if params[:role].present?
        UserRole.create(:role => params[:role].to_i, :user => @executive)
      end
      step = params[:proceed_next] ? 2 : 1
      redirect_to edit_executive_path(@executive, :step => step)
    else
      render 'new'
    end
  end

  # GET /executives/1/edit
  def edit
    common_nav_header_menu
    @step = params[:step] || 1
  end

  # PATCH/PUT /executives/1
  # PATCH/PUT /executives/1.json
  def update
    common_nav_header_menu
    if params[:open_card] == "true"
      flash.keep[:notice] = t("general.information_saved")
    end

    if params[:step].to_i == 2
      set_other_languages @executive
      check_user_skills @executive
      set_other_job_role @executive
    end

    if !params[:user].present?
      @executive.update_attributes(:registered => true) unless @executive.registered
      flash.keep[:notice] = t("executive.executive_updated")
      redirect_to executives_path
    elsif @executive.update(executive_params.merge(updater: current_user))
      step = params[:proceed_next] ? (params[:step].to_i + 1) : (params[:step].to_i)
      redirect_to edit_executive_path(@executive, :step => step, :open_card => open_card_param)
    else
      @step = params[:step]
      render 'edit'
    end
  end

  # DELETE /executives/1
  # DELETE /executives/1.json
  def destroy
    @executive.destroy
    respond_to do |format|
      format.html { redirect_to executives_url, notice: t("executive.executive_destroyed") }
      format.json { head :no_content }
    end
  end


  def user_register
  	user_register_header
  end

  def business_management
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
                          {:href => executives_path, :label => t("nav_header.executives"), :arrowBack => true}
                        ]      
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_executive
    @executive = @current_brand.users.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def executive_params
    params.require(:user).permit(:brand_id, :email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :ssn, :address, :phone_number, :post_number, :city, :personal_email, :gender, :contract_start_date, :contract_end_date, :contract_type, :contract_probation, :creator_id, :updater_id, :relationship_type, :perform_dentist_work, :sv_number,
                                 :job_role, :other_job_role, :other_business_degrees, :introduction, resources_attributes: [ :id, :media, :resource_type_id, :resource_spec_id ], languages:[])
  end

  private

  def fetch_users
    users = @current_brand.users.executives
    
    if params[:search].present?      
      search = session[:executive_search] = params[:search]
    else
      if params[:role].present?
        search = session[:executive_search] = nil
      else
        search = session[:executive_search] if session[:executive_search].present?
      end
    end
    if search.present?
      session[:executive_search] = search
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