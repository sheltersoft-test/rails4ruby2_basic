class Resource < ActiveRecord::Base
  
  belongs_to :resource_holder, polymorphic: true, inverse_of: :resources
  belongs_to :resource_type
  belongs_to :resource_spec

  has_attached_file :media,
                    styles: lambda { |a| a.instance.media_content_type =~ %r(image) ? {:small => {:geometry => "100x100"}, :medium => {:geometry => "256x256"} }  : {} },
                    convert_options: { all: '-auto-orient' },
                    path: :media_path,
                    url: :media_url,
                    default_url: :media_default_url,
                    processors: [:dispatcher]

  validates_attachment_content_type :media, 
                                    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf", "application/vnd.ms-excel",
                                                      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", 
                                                      "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain", 'application/vnd.ms-powerpoint']

  #validates_attachment_size :media, :less_than => lambda { |a| eval(a.current_media_size_limit) }

  validates :resource_holder_type, :presence => true
  validates :resource_spec_id, :presence => true
  validates :resource_type_id, :presence => true

  def current_media_size_limit
    case resource_type.name
    when "IMAGE"
      Settings.paperclip.media_size_limit.image
    when "DOCUMENT"
      Settings.paperclip.media_size_limit.document
    else
      Settings.paperclip.media_size_limit.default
    end
  end  

  def get_remote_url brand, style="original"
    begin
      protocol = brand.slug == "dsd" ? "https:" : "http:"
      # Support for both good and bad URI's
      url = URI("#{protocol}//#{brand.slug}.#{Settings.system.domain}#{media.url(style.to_sym)}")
      response = ((Net::HTTP.new url.host).request_head url.path).code.to_i
       (response == 200 or response == 301) ? url : ""
    rescue
      ""
    end
  end

  private

  def media_path
    resource_spec.limited ? Settings.content.resource.media_path_limited : Settings.content.resource.media_path
  end

  def media_url
    resource_spec.limited ? Settings.content.resource.media_url_limited : Settings.content.resource.media_url
  end

  def media_default_url
    Settings.content.resource.media_default_url
  end
end
