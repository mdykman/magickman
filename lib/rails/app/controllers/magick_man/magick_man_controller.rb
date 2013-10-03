#require 'magickman'

module MagickMan
  class MagickManController  < ApplicationController
    def initialize
    end

    def serve
      filepath= "#{params[:imgpath]}.#{params[:format]}"
      mm = MagickManager.instance
      if not mm.supportsType? params[:format]
        logger.warn "unsupported type requested in #{filepath}, redirecting to origin with 302"
        redirect_to filepath, :status => 302
        return
      end

      img = mm.resolve filepath
      if img and File.exists? img
        expires_in Integer(mm.cachetime).seconds, :public => true
        send_file img, :disposition => params[:attachment] ? 'attachment':'inline'
        return
      else
        img = mm.notfound filepath
        # let the regular resource server report the error
        logger.info "not found, redirecting to #{img} with 303"
        redirect_to img, :status => 303
        return
      end
    end  # end of serve
  end
end
