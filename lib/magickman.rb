#require "magickman/version"
require 'fileutils'

module MagickMan
  class MagickManager
    def self.instance(conf = {})
      @@instance ||= MagickManager.new conf
    end

    def self.config
      mm = {} 
      if block_given?
        yield mm
      end
      MagickManager.instance mm
    end
    
    def bootstrap_controller
	 	cc = File.join(File.dirname(__FILE__),'rails/app/controllers')
    Rails.application.paths["app/controllers"] <<  cc
		$LOAD_PATH << cc
		require 'magick_man/magick_man_controller'
    end
    
    def format(src,fmt) 
      r = nil
      ff = @formats[fmt]
      if(ff)
        if src =~ /^(\/)?([^\/].*?)[.](#{@types.join '|'})$/
          ext = @preferred || $3
          r= "/#{@prefix}/images/#{$2}#{@csep}#{fmt}.#{ext}"
		  puts "formats returning #{r}"
        end
      end
      r
    end
    
    def supportsType?(str) 
      @types.include?(str)
	 end

    def initialize(conf)
      @preferred = conf[:preferred]
      @convert = conf[:convert] || '/usr/local/bin/convert'
      @csep = conf[:csep] || '.'
      @desttype = conf[:desttype]
      @targetbase = conf[:target] || Rails.public_path.to_s
      @prefix = conf[:prefix] || 'magickman'
      @types =  conf[:types] || %W[jpg png]
      @formats =  conf[:formats] || {
          :small=>  '-resize 100 100>',
          :medium=> '-resize 400 400>',
          :large=>  '-resize 800 800>'
      }
      @srcpaths = conf[:sources] || []
      if not conf[:ignorestd]
        @srcpaths.push Rails.public_path.to_s 
        @srcpaths.concat Rails.application.config.assets.paths.select { 
          |p| p.end_with?('images') }.map { 
            |q| File.dirname q }
        
      end
    end
      # set the routes

    def findimage(path)
      @srcpaths.each { |p|
        ts = "#{p}/#{path}"
		  puts "searching #{ts}"
        if File.exists? ts
          return ts
        end  
      }
      nil
    end
  
  def findsource(path)
      pp = path
      format = nil
      # derive the source name, if any
      if path =~ /^(.*?)#{@csep}(#{@formats.keys.join '|'})[.](#{@types.join '|'})/
         puts "matched"
         format = $2
         pp = "#{$1}.#{@desttype || $3}"
      end

      if format && (source = findimage pp) then return {
        :directory => @targetbase,
        :target => "#{@targetbase}/#{path}",
        :source => source,
        :format => format,
        :transform => @formats[format.to_sym]
      }
      end
      nil
    end
        
    def convert(options)
      puts "convert options #{options.inspect}"
      target = options[:target]
      base = File.dirname target
      puts "convert:: target  #{target}, base  #{base}"
      FileUtils.mkpath base
      puts %Q[command line:: #{@convert} #{options[:source]} #{options[:transform]} #{options[:target]}]
      %x[#{@convert} #{options[:source]} #{options[:transform]} #{options[:target]}]
      result = $?
      return (0 == result.exitstatus)
    end

  end
end
