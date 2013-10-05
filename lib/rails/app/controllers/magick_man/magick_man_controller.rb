#require 'magickman'

module MagickMan
  class MagickManController  < ApplicationController
    def initialize
    end

    def manage
      logger.info "manage called"
    end

    def serve
      if not params[:imgpath]
        manage
      else

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
          imgl = nil
          if img
            imgl = mm.resolve img
          end
          logger.info "img = #{img} and imgl = #{imgl}"
          if not (img and imgl)
            raise ActionController::RoutingError.new('Not Found')
#           render :file => "#{RAILS_ROOT}/public/404.html",  :status => 404
          else
            if mm.strict
              if params[:attachment]
                raise ActionController::RoutingError.new('Not Found')
              else
                send_file imgl, :status => 404, :disposition => 'inline'
              end
            else
              logger.info "not found, redirecting to #{mm.prefix}/#{img} with 303"
              redirect_to "/#{mm.prefix}/#{img}", :status => 303
            end
          end
        end
      end
    end  # end of serve
  end # end of class
end # end of module
