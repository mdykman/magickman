#require 'AssetTagHelper'
require 'magickman'

# configure magickman
Magickman::MagickMan.config do |conf|
# path to convert
  conf[:convert] = '<%= @convert  %>'
# prefix to active magickman server: default 'magickman'
  conf[:prefix] = '<%= @prefix %>'
# destination folder for newly created files: default 'public'
  conf[:target] = '<%= @target %>'
  conf[:csep] = '.'
# types of files to handle
  conf[:type] = %W[jpg png]
# named formats
  conf[:formats] = {
# non-cropping, best-fit
    :thumb =>  '-resize 100 100>',
    :small =>  '-resize 400 400>',
    :medium => '-resize 600 600>',
    :large =>  '-resize 800 800>'
  }
  
# optionally limit/specify source directories
#  conf.sources = %W[public]
end

# setup the intercept route for the controller
Rails.application.routes.prepend do
  get "<%= @prefix %>/*imgpath", :to=>"magick_man#serve"
end

# enable the tag
module ActionView
  module Helpers
    module AssetTagHelper
      def magick_image_tag(source, format, options = {})
        mm = MagickMan::MagickMan.instance
        src = mm.format source
        image_tag src, options
      end
    end
  end
end
