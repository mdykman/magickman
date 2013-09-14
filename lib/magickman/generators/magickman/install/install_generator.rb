require 'rails'

module MagickMan
  module Generators
    class InstallGenerator < Rails::Generator::Base
# doubt I need this for what I am using
      source_root File.expand_path("../templates", __FILE__)
      argument :prefix => 'magickman', :target => 'public'
      @convert = %x[which convert]
      
#      def create_magickman_route
#        route "get #{@prefix}/*imgpath  magickman/MagickmanController#serve"
#      end    
        
      def create_magickman_initializer_file
        initializer 'magickman.rb'  do        
          require 'magickman'
          MagickMan::MagickMan.config do |conf|
          # path to convert
            conf.convert = '#{@convert}'
          # prefix to active magickman server: default 'magickman'
            conf.prefix = '#{@prefix}'
          # destination folder for newly created files: default 'public'
            conf.target = '#{@target}'
            conf.csep = '.'
         # types of files to handle
            conf.types = %W[jpg png]
          # named formats
            conf.formats = {
          # non-cropping, best-fit
              :thumb =>  '-resize 100 100>',
              :small =>  '-resize 400 400>',
              :medium => '-resize 600 600>',
              :large =>  '-resize 800 800>'
            }
            
          # optionally limit/specify source directories
          #  conf.sources = %W[public]
          end
          Rails.application.routes.prepend do
            get "#{@prefix}/*imgpath", :to=>"magickman/MagickmanController#serve"
          end

# Rails.application.routes.prepend do
#  get "#{@prefix}/*imgpath", :to=>"magickman/MagickmanController#serve"
# end


        end # end of intializer
#        template 'magickman.rb', File.join('config','initializers','magickman.rb')
      
      end # end of create_magickman_initializer_file
  end # end of class InstallGenerator
end # end of module Generators
end # end of module Generators