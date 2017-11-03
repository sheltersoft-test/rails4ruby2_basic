class DentistsController < ApplicationController

  before_action :authenticate_executive!, except: [:desktop]
  before_action :authenticate_dentist!, only: [:desktop]

	before_action :set_dentist, only: [:show, :edit, :update, :destroy]

  # GET /executives
  # GET /executives.json
  def index
    @nav_header_menus = [
                          {:href => desktop_executives_path, :label => t("nav_header.executive_desktop"), :arrowBack => false},
                          {:href => user_register_executives_path, :label => t("nav_header.user_register"), :arrowBack => true}
                        ]
    @back_to_top = true
    @dentists = fetch_users.page(page).per(first_limit)
  end

  def user_filter
    @dentists = fetch_users.page(page).per(first_limit)
  end

  def next_users
    @dentists = fetch_users.page(page).per(limit)
    render layout: false
  end  

  # GET /executives/1
  # GET /executives/1.json
  def show
    # common_nav_header_menu
  end

  # GET /executives/new
  def new
    # common_nav_header_menu
    # @step = 1
    # @executive = User.new
    # @secure_pass = SecureRandom.hex(6)
  end

  # POST /executives
  # POST /executives.json
  def create
    # common_nav_header_menu
    # @executive = User.new(executive_params)
    # @secure_pass = SecureRandom.hex(6)
    # @step = 1
    # if @executive.save
    #   step = params[:proceed_next] ? 2 : 1
    #   redirect_to edit_executive_path(@executive, :step => step)
    # else
    #   render 'new'
    # end
  end

  # GET /executives/1/edit
  def edit
    # common_nav_header_menu
    # @step = params[:step] || 1
  end

  # PATCH/PUT /executives/1
  # PATCH/PUT /executives/1.json
  def update
  end

  # DELETE /executives/1
  # DELETE /executives/1.json
  def destroy
    @dentist.destroy
    respond_to do |format|
      format.html { redirect_to executives_url, notice: t("executive.executive_destroyed") }
      format.json { head :no_content }
    end
  end


  def user_register
  	user_register_header
  end


  def user_register_header
    @nav_header_menus = [
                          {:href => root_path, :label => t("nav_header.dentist_desktop"), :arrowBack => true}
                        ]
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dentist
    @dentist = @current_brand.users.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dentist_params
    params.require(:user).permit(:brand_id, :email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :ssn, :address, :phone_number, :post_number, :city, :personal_email, :gender, :contract_start_date, :contract_end_date, :contract_type, :contract_probation, :creator_id, :updater_id,
                                 :job_role, :other_business_degrees, :introduction, resources_attributes: [ :id, :media, :resource_type_id, :resource_spec_id ], languages:[])
  end

  private

  def fetch_users
    users = @current_brand.users.dentists
    
    if params[:search].present?      
      search = session[:dentist_search] = params[:search]
    else
      if params[:role].present?
        search = session[:dentist_search] = nil
      else
        search = session[:dentist_search] if session[:dentist_search].present?
      end
    end
    if search.present?
      session[:dentist_search] = search
      users = users.where('first_name LIKE ? or last_name LIKE ? or city LIKE ?', "%#{search}%", "%#{search}%", "%#{search}%")
    end
    users.order('id DESC').uniq
  end
end
