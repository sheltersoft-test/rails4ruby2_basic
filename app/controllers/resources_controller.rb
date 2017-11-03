class ResourcesController < ApplicationController

  before_action :authenticate_user!

  include ApplicationHelper

  def download
    if current_user
      # get resource
      resource = Resource.find resource_params[:id]
      # return error if no resource
      return render_error ActiveRecord::RecordNotFound.new unless (resource.present?)      

      return render_error :unauthorized, t('resources.download.no_authorizations') unless is_valid_authorization?(resource)
      
      file_path = resource.media.path
      media_file_name = resource.media_attachment_name.present? ? resource.media_attachment_name : resource.media_file_name
      if params[:unknown_extention] == "true"
        media_file_name = media_file_name + "." + MIME::Types[resource.media.content_type].first.extensions.first
      end
      send_file(file_path,
                :filename => media_file_name,
                :type => resource.media.content_type, 
                :disposition => 'attachment')

    else
      # if not logged in
      return redirect_to root_path
    end
  end

  def get_resource_holders
    resource_holders = []
    if params[:resource_holder_type].present?
      begin
        resource_holder_type = params[:resource_holder_type].classify.constantize
        if resource_holder_type.is_a?(Class)
          resource_holders = resource_holder_type.all.map{|h| {id: h.id, name: h.name}}
        end
      rescue
      end
    end
    respond_to do |format|
      format.json { render json: {"resource_holders": resource_holders} }
    end
  end

  def save_media
    begin
      object = nil
      if params[:type] == 'User'
        object = @current_brand.users.find(params[:id])
      end
      if object and params[:media].present?
        resource_type = ResourceType.find_by(name: params[:resource_type])
        resource_spec = ResourceSpec.find_by(name: params[:resource_spec])
        if resource_type and resource_spec
          k = 0
          params[:media].each do |media|
            if media.present?
              coordinate = params[:coordinate].present? ? params[:coordinate][k] : ''
              object.resources.create(resource_type: resource_type, resource_spec: resource_spec, media_attachment_name: coordinate, media: media)
              k = k + 1
            end
          end
        end
        success = true
      else
        success = false
      end
    rescue Exception => e
      success = false
    end
    respond_to do |format|
      format.json { render json: {"success": success} }
    end
  end

  def delete_media
    begin
      object = nil
      if params[:type] == 'User'
        object = @current_brand.users.find(params[:id])
      end
      if object.present?
        media = object.resources.find(params[:media_id])
        if media.present?
          media.destroy
          success = true
        else
          success = false
        end
      else
        success = false
      end
    rescue Exception => e
      success = false
    end
    respond_to do |format|
      format.json { render json: {"success": success} }
    end
  end
 
  private

  def is_valid_authorization?(resource)
    #resource.resource_holder == current_user
    true
  end

  def render_error code,message
    render template: 'errors/error_500.html.haml', status: code, content_type: 'text/html'
  end

  def user_account_authorized? resource
    resource.user == current_user
  end

  def resource_params
    params.permit(:id)
  end

end