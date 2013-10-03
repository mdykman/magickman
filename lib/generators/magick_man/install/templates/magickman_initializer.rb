#require 'AssetTagHelper'
require 'magickman'

# configure magickman
mm = MagickMan::MagickManager.config do |conf|
# path to convert
  conf[:convert] = '<%= @convert  %>'
# prefix to active magickman server: default 'magickman'
  conf[:prefix] = '<%= @prefix %>'
# destination folder for newly created files: default 'public'
  conf[:target] = '<%= @target %>'
  conf[:csep] = '.'
# types of files to handle
  conf[:type] = %W[jpg png]
# time, in seconds. for cache control header
  conf[:cachetime] = 3600
    
#default not found image, processed as per requested type
  conf[:notfound] = "not-found.jpg"
 # custom, per-type.. not processed
  conf[:notfoundtypes] = {
    :thumb => 'thumbnot.jpg'
  }

  conf[:logger] = Logger.new(STDOUT)  
# named formats
  conf[:formats] = {
# non-cropping, best-fit
    :thumb =>  '-resize 100x100\>',
    :small =>  '-resize 400x400\>',
    :medium => '-resize 600x600\>',
    :large =>  '-resize 800x800\>'
  }

end

mm.bootstrap_controller

# setup the intercept route for the controller
Rails.application.routes.prepend do
  get "<%= @prefix %>/*imgpath(.:format)", :to=>"magick_man/magick_man#serve", :as => '<%= @prefix %>'
end

# enable the tag
module ActionView
  module Helpers
    module AssetTagHelper
      def magick_tag(source, format, options = {})
        mm = MagickMan::MagickManager.instance
        src = mm.format source, format
        image_tag src, options
      end
    end
  end
end
