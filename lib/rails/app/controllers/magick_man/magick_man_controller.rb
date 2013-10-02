#require 'magickman'

module MagickMan
  class MagickManController  < ApplicationController
    def initialize
    end

    def serve
      filepath= "#{params[:imgpath]}.#{params[:format]}"
      mm = MagickManager.instance
      if not mm.supportsType? params[:format]
        logger.warn "unsupported type requested #{filepath}"
        redirect_to filepath, status: 302
        return
      end

      img = mm.resolve filepath
      if not img
        nf = mm.notfound filepath
        if nf
          img = mm.resolve nf
        end
      end

      if File.exists? img
        expires_in Integer(mm.cachetime).seconds, :public => true
        send_file img, :disposition => params[:attachment] ? 'attachment':'inline'
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
