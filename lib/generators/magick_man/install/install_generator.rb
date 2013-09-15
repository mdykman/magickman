require 'rails'

module MagickMan
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      class_options :prefix => 'magickman', :target => 'public', :convert => false

      def create_magickman_initializer_file
        @convert = options[:convert] || %x[which convert]
          #TODO:: this would be a good time to check the availability of convert
        @prefix = options[:prefix]
        @target = options[:target]
        template  'magickman.rb'  , File.join('config','initializers','magickman.rb')
      end # end of create_magickman_initializer_file
    end # end of class InstallGenerator
  end # end of module Generators
end # end of module MagickMan
