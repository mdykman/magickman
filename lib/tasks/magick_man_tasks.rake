namespace :magick_man do
  desc 'clean generated files'
  task :clean do
    load "#{Rails.root}/config/initializers/magickman.rb"
    MagickManager.instance.clean
  end
end

module MagickMan
  module Tasks
    class MagickManTasks 
      def initialize(configuration, root = Rails.root)
        @configuration, @root = configuration, root
      end
      
      def clean
        mm = MagickManager.instance
        
        mm.clean
      end
    end
  end
end