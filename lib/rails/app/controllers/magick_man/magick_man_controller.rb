#require 'magickman'

module MagickMan
  class MagickManController  < ApplicationController
    def initialize
    end

    def serve
      # remove the first component
      filepath= "#{params[:imgpath]}.#{params[:format]}"
#      puts "loading from req path #{filepath}"

      mm = MagickManager.instance

      if not mm.supportsType? params[:format]
#        puts "unsupported type requested: #{params[:format]}"
        redirect_to filepath, status: 302
        return
      end

      img = mm.findimage(filepath)
      if not img
        src = mm.findsource filepath
        if src
          rr = mm.convert src
          if rr
            img = src[:target]
          end
        end
      end

      if File.exists? img
#        puts "serving #{img}"
        expires_in 30.days, :public => true
        send_file img, :disposition => params[:attachment] ?  'attachment' : 'inline'
        return
      else
        # let the regular resource server report the error
        puts "redirecting to #{filepath} #{__LINE__}"
        redirect_to img, status: 303
        return
      end
    end  # end of serve
  end

end
