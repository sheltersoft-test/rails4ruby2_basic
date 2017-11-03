require "net/http"

module ApplicationHelper

  def resources_url_by_ids(type_spec, resource_holder_type='', ids=[], default_url="customer_register.png", style="small")
    type, spec = type_spec.to_s.split '::'
    conditions = { :'resource_types.name' =>  type }
    conditions[:'resource_specs.name'] = spec if spec.present?
    conditions[:'resources.resource_holder_type'] = resource_holder_type if resource_holder_type.present?
    resources = Resource.includes(:resource_type, :resource_spec).where(conditions).where("resources.resource_holder_id IN (?)", ids)
    resources_hash = {}
    resources.each do |resource|
      resources_hash[resource.resource_holder_id] = resource
    end
    resources_url = {}
    ids.each do |id|
      resource = resources_hash[id]
      resources_url[id] = (resource.present? and resource.media.present?) ? resource.media.url(style.to_sym) : (default_url.present? ? default_url : '')
    end
    resources_url
  end  

  def validate_remote_url?(file)
    begin
      # Support for both good and bad URI's
      uri = URI.parse(URI.escape(URI.unescape(file)))
      response = nil
       Net::HTTP.start(uri.host, uri.port) {|http|
         response = http.head(uri.path)
       }
       # .. response.content_type == "audio/mpeg"
       response.code == "200"
    rescue
      false
    end
  end

  def absolute_assets_url(filename, brand)
    if brand.custom_domain.present?
      "http://#{brand.custom_domain}/assets/images/pdf/#{filename}"
    else
      "http://#{brand.slug}.#{Settings.system.domain}/assets/images/pdf/#{filename}"
    end
  end

  def absolute_url(path, brand)
    if brand.custom_domain.present?
      url = "http://#{brand.custom_domain}#{path}"
    else
      url = "http://#{brand.slug}.#{Settings.system.domain}#{path}"
    end
    return url
  end

  def ajax_redirect_to(redirect_uri)
    { js: "window.location.replace('#{redirect_uri}');" }
  end
  
  def ios?
    request.user_agent =~ /iPhone|iPad|iPhone/i
  end

  def android?
    request.user_agent =~ /Android/i
  end

  def pc?
    !ios? && !android?
  end

  def safari?
    begin
      user_agent = UserAgent.parse(request.user_agent)
      puts "Browser: -----------------> #{user_agent.browser}"
      user_agent.browser == "Safari"
    rescue Exception => e
      false
    end
  end

  def set_proper_name(name, max_length = nil)
    if name.present?
      max_length = max_length || 15
      if name.length < max_length
        name
      else
        name[0..(max_length - 5)] + "..."
      end
    end
  end

  def sanitize_filename(filename)
    fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m
    fn[0] = fn[0].parameterize
    return fn.join '.'
  end

  def convert_to_number(number, flt = true)
    number = number.to_s.gsub(" ", "").gsub(",", ".")
    if flt
      number.to_f.round(2)
    else
      number
    end
  end

  def btn_height_class
    params[:open_card] == "true" ? "h50" : "h25"
  end
end
