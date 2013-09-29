require 'rails'
require 'magickman'

module MagickMan
  module Generators
    class InstallGenerator < Rails::Generators::Base
#      source_root File.expand_path("templates", __FILE__)
      source_root File.expand_path("../templates", __FILE__)
      class_options :prefix => 'magickman', :target => 'public', :convert => false

      def create_magickman_initializer_file
#        puts "template path #{templates_path}"
        
        @convert = options[:convert] || %x[which convert].chomp
          #TODO:: this would be a good time to check the availability of convert
        @prefix = options[:prefix]
        @target = options[:target]
        iif = File.join('config','initializers','magickman.rb')
        template  'magickman_initializer.rb'  , iif
        puts "configuration can be managed by editing #{iif}"
      end # end of create_magickman_initializer_file
      
    end # end of class InstallGenerator
  end # end of module Generators
end # end of module MagickMan
