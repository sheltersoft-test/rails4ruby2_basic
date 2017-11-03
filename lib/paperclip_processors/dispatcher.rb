module Paperclip
  require 'net/ftp'
  require 'uri'

  # class MediaTypeSpoofDetector
  #   def spoofed?
  #     false
  #   end
  # end

  class BaseProcessor < Processor

    def initialize(file, options={}, attachment=nil)
      super
      @resource = attachment.instance
      @file           = file
      @attachment     = attachment
      @current_format = File.extname(@file.path) 
      log " current_format ---  #{@current_format} "
      @format         = options[:format]
      log " format ---  #{@format} "
      @geometry       = options[:geometry]
      @basename       = File.basename(@file.path, @current_format)
    end

    def log(message)
      Paperclip.log message
    end

    def logger
      Paperclip.logger
    end

    def temp_file(basename, extension, data=nil)
      # Paperclip::Tempfile, ref. https://github.com/thoughtbot/paperclip/blob/master/lib/paperclip/tempfile.rb
      # FIXEME: tempfile extension
      t = Tempfile.new [basename, extension]
      t.binmode
      t.write data if data.present?
      t.rewind
      t
    end

    def file(source)
      File.expand_path(source.path)
    end
  end

  class Dispatcher < BaseProcessor
    def make
      log 'dispatcher: starting paperclip process...'      
      resource_type = @resource.resource_type
      if resource_type and resource_type.name == 'IMAGE'
        log 'dispatcher: IMAGE has been detected'
        output = ImageMagick.new(@file, @options, @attachment).make
      else
        output = Void.new(@file, @options, @attachment).make
      end
      output
    rescue
      log 'dispatcher: an error has occurred during processing resource:'
      log $ERROR_INFO.message
    end
  end

  class Void < BaseProcessor
    def make
      log 'void processor: just do nothing, saving...'
      File.open @file.path
    end
  end

  class ImageMagick < BaseProcessor

    def make
      log 'imagemagick processor: processing image...'

      resource_spec = @resource.resource_spec

      if resource_spec.name == 'OFFICE_TEXT_LOGO'
        @from_extension = File.extname(file(@file))
        @from_basename = File.basename(file(@file), @from_extension)
        temp = temp_file @from_basename, '.png'
        font_file = "#{Rails.root}/app/assets/fonts/HelveticaNeueLTMd.ttf"
        text = @resource.resource_holder.logo_text
        command = "-i #{file(@file)} -vf 'drawtext=fontfile=#{font_file}: \ text=#{text}: fontcolor=blue: fontsize=24: x=w-tw-25:y=h-th-8' -y #{file(temp)}"
        Paperclip.run('ffmpeg', command)
      elsif (resource_spec.name == 'USER_PHOTO' or resource_spec.name == 'OFFICE_PHOTO') and @resource.media_attachment_name.present?
        crop_temp = temp_file @basename, @current_format
        coordinate = @resource.media_attachment_name.gsub(",", ":")
        command = "-i #{file(@file)} -vf crop='#{coordinate}' -y #{file(crop_temp)}"
        Paperclip.run('ffmpeg', command)
        temp = temp_file @basename, @current_format
        command = "convert #{file(crop_temp)} -thumbnail #{@geometry} -flatten -auto-orient #{file(temp)}"
        Paperclip.run(command)
      else
        temp = temp_file @basename, @format
        command = "convert #{file(@file)} -thumbnail #{@geometry} -flatten -auto-orient #{file(temp)}"
        Paperclip.run(command)
      end
      
      sleep(2)

      temp
    rescue
      log 'imagemagick processor: an error has occurred during processing resource:'
      log $ERROR_INFO.message
      @temp
    end
  end
end