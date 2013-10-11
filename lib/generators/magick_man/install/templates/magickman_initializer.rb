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
#    :thumb => 'thumbnot.jpg'
  }

  conf[:logger] = Logger.new(STDOUT)  
# named formats
  conf[:formats] = {
# non-cropping, best-fit
    :thumb =>  '-resize 50x50\>',
    :small =>  '-resize 100x100\>',
    :medium => '-resize 200x200\>',
    :large =>  '-resize 400x400\>',
# center-cropped, forced-fit
    :ct => '-resize 50x50^ -gravity center -extent 50x50',
    :cs => '-resize 100x100^ -gravity center -extent 100x100',
    :cm => '-resize 200x200^ -gravity center -extent 200x200',
    :cl => '-resize 400x400^ -gravity center -extent 400x400'
  }

end

mm.bootstrap_controller

# setup the intercept route for the controller
Rails.application.routes.prepend do
# this is to enable the dev/admin page, may be disabled in production
  get "<%= @prefix %>/manage", :to=>"magick_man/magick_man#manage", :as => '<%= @prefix %>_manage'

  # this is the path for the core service
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
