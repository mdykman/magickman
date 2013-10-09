require 'magickman/version'
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

    def initialize(conf)
      @strict = conf[:strict] || false
      @cachetime = conf[:cachetime] || 3600
      @preferred = conf[:preferred]
      @convert = conf[:convert] || '/usr/local/bin/convert'
      @csep = conf[:csep] || '.'
      @desttype = conf[:desttype]
      @notfound = conf[:notfound] || "notfound.png"
      @notfoundtypes = conf[:notfoundtypes] || {}
      @targetbase = conf[:target] || Rails.public_path.to_s
      @prefix = conf[:prefix] || 'magickman'
      @types =  conf[:types] || %W[jpg png]
      @formats =  conf[:formats] || {
        :small=>  '-resize 100 100>',
        :medium=> '-resize 400 400>',
        :large=>  '-resize 800 800>'
      }
      Rails.application.paths["app/views"] << File.join(File.dirname(__FILE__),'views')
      Rails.application.config.assets.paths << File.join(File.dirname(__FILE__),'assets/images')
      @logger = conf[:logger] || Logger.new(STDOUT)
    end

    def cachetime
      @cachetime
    end

    def strict
      @strict
    end
    
    def formats
      @formats
    end
    # set the routes
    def bootstrap_controller
      # put the controller on the path
      cc = File.join(File.dirname(__FILE__),'rails/app/controllers')
      Rails.application.paths["app/controllers"] <<  cc
      $LOAD_PATH << cc
      require 'magick_man/magick_man_controller'
    end

    def prefix
      @prefix
    end

    def formatlocal(src,fmt)
      ff = @formats[fmt]
      if(ff)
        pp = parsefile src
        if src =~ /^(\/)?([^\/].*?)[.](#{@types.join '|'})$/
          ext = @preferred || $3
          return "images/#{$2}#{@csep}#{fmt}.#{ext}"
        end
      end
      nil
    end

    def format(src,fmt)
      "/#{prefix}/#{formatlocal(src,fmt)}"
    end

    def supportsType?(str)
      @types.include?(str)
    end

    def resolve(filepath)
      img = findimage(filepath)
      if not img
        src = findsource filepath
        if src
          img = src[:target]
          if @logger
            @logger.info "creating image ${img}"
          end
          rr = convert src
        end
      end
      img
    end

    def parsefile(path)
      if path =~ /^(.*?)#{@csep}(#{@formats.keys.join '|'})[.](#{@types.join '|'})/
        return [$1,$2,$3]
      end
      nil
    end

    def notfound(path)
      img = nil
      pp = parsefile path
      if pp
        img = @notfoundtypes[pp[1].to_sym]
        if not img
          img = formatlocal @notfound,pp[1].to_sym
        end
        img
      end
    end
    #	 def cachetime
    #	   @cachetime
    #	 end

    def clean
      pp=Dir("#{@targetbase}/images/**/*#{csep}(#{@formats.keys.join '|'}).(@type.join '|')")
      puts "clean found #{pp}"
      pp.each {|p|
        puts "deleting #{p}"
        p.delete
      }
    end

    def findimage(path)
      ff = [Rails.public_path.to_s]
      if not @ignorestd
        ff.concat Rails.application.config.assets.paths.map { |p|
          File.dirname p
        }.uniq
      end
      ff = ff.select { |p|
        @logger.info "searching #{p}/#{path}"
        File.exists? "#{p}/#{path}"
      }.map { |q|
        if @logger
          @logger.info "found #{q}/#{path}"
        end
        "#{q}/#{path}"
      }.uniq
      if(ff.length)
        return ff[0]
      end
      nil
    end

    def findsource(path)
      pp = path
      format = nil
      # derive the source name, if any
      pp = parsefile path
      if pp
        format = pp[1]
        pp = "#{pp[0]}.#{@desttype || pp[2]}"
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
      target = options[:target]
      base = File.dirname target
      source = options[:source]
      transform = options[:transform]
      if @logger
        @logger.info "convert: creating #{target} from #{source}"
      end
      if not File.exists? base
        if @logger 
          @logger.info "creating directory #{base}"
        end
        rr = FileUtils.mkpath base
#        if(!rr)
        if(true and @logger)
          @logger.info "creating directory #{base} returned #{rr}"
        end
      end
      if transform.lstrip.chr != '-'
        cmd = %Q[ #{transform} #{source}  #{target}]
      else
        cmd = %Q[ #{@convert} #{source} #{transform} #{target}]
      end
      if @logger
        @logger.warn "command: #{cmd}"
      end
      outp = %x[#{cmd}]
      if outp and outp.length
        if @logger
          @logger.warn outp
        else
          puts outp
        end
      end
      if ((File.exists? target) and (0 == $?.exitstatus))
        return true
      end
      
      if @logger
        @logger.warn "convertion failed. #{$?.exitstatus} returned for command #{cmd}"
      end
      false
    end

  end
end
