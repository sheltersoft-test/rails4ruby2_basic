
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery 
  # with: :exception

  before_filter :current_brand

  before_filter :set_locale

  helper_method :current_brand_custom_domain_or_subdomain, :current_brand_custom_domain_or_slug

  include ApplicationHelper

  LOCALE_LANG = ["en", "fi"]

  class BrandNotFound < StandardError
  end  

  def page
    params[:page] || 1
  end

  def limit
    params[:per] || Settings.system.per_page
  end

  def first_limit
    params[:per] || Settings.system.per_page_first
  end  

  def current_brand
    begin
      @current_brand ||= Brand.find_by_slug(session[:current_brand_slug]) || Brand.find_by_custom_domain(request.host) || Brand.find_by_slug('dbm')
    rescue ActiveRecord::RecordNotFound => e
      raise BrandNotFound
    end
  end  

  def current_brand_custom_domain_or_subdomain
    @current_brand.custom_domain ? @current_brand.custom_domain : request.subdomain
  end

  def current_brand_custom_domain_or_slug
    @current_brand.custom_domain ? @current_brand.custom_domain : @current_brand.slug
  end

  private

  def authenticate_executive!
    redirect_to root_path if authenticate_user! and !current_user.executive?
  end

  def authenticate_director!
    redirect_to root_path if authenticate_user! and !current_user.director?
  end

  def authenticate_dentist!
    redirect_to root_path if authenticate_user! and !current_user.dentist?
  end

  def set_lang_cookie
    # set language cookie using query string parameter 'lang'
    session[:lang] = params[:locale] if params[:locale] and LOCALE_LANG.include?(params[:locale])
  end
  
  def set_locale
    set_lang_cookie
    I18n.locale = session[:lang] || params[:locale] || I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if request.env['HTTP_ACCEPT_LANGUAGE']
  end

  def open_card_param
    params[:open_card].present? ? params[:open_card] : false
  end

  def check_user_skills user
    params[:language_skills].present? ? set_user_skills(:language_skills, user) : user.language_skills.destroy_all
  end

  def set_other_languages user
    new_languages = []
    if user.languages.present?
      current_languages = user.languages.split(",")
      current_languages.each do |current_language|
        new_languages.push(current_language) if params["language_#{current_language}"].present? and params["language_#{current_language}"] == "true"
      end
    end
    if params[:languages].present?
      params[:languages].each do |key,value|
        new_languages.push(value) unless new_languages.include?(value)
      end
    end
    user.languages = new_languages.join(",")
  end

  def set_user_skills skill_type, user
    skills = []
    params[skill_type].each do |skill_id|
      skills << user.user_skills.find_or_create_by(skill_id: skill_id, skill_type: skill_type.to_s.camelize.singularize)
    end
    skills_to_be_removed = user.user_skills.where(skill_type: skill_type.to_s.camelize.singularize) - skills
    skills_to_be_removed.each{|s| s.destroy} if skills_to_be_removed.present?
  end

  def set_pdf_asset_url
    request_protocol = Rails.env.development? ? "//" : request.protocol
    if @current_brand.custom_domain.present?
      @domain_url = "#{request_protocol}#{@current_brand.custom_domain}/default/pdf/"
    else
      @domain_url = "#{request_protocol}#{@current_brand.slug}.#{Settings.system.domain}/default/pdf/"
    end
  end
end
