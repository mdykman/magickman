require 'magickman'

module MagickMan
	class MagickManController
	  
		def initialize 
		end

		def serve
			# remove the first component
      puts("loading from path ${:imgpath}")
			filepath=:imgpath
			parts=filepath.split '/'
			parts.shift
			filepath=parts.join '/'
			puts("loading from path ${filepath}")
      
			mm = Magickman::Magickman.instance
      
      if not mm.supportsType? filepath
        puts "unsupported type requested: #{filepath}. #{mm[:types]} allowed"
        redirect_to filepath, status: 302
      end
      
			if not File.exists filepath
				src = mm.findsource filepath
				if src
          mm.convert src
#				else 
#					raise ActionController::RoutingError.new("Source Not Found for #{src[:path]}")
				end
			end
			
			if File.exists filepath
			  expires_in 30.days, public => true
				send_file filepath, :disposition => params[:attachment] ?  'attachment' : 'inline'
			else
			  # let the regular resource server report the error
        redirect_to filepath, status: 301
#				raise ActionController::RoutingError.new('Not Found')
			end
		end  # e[nd of serve
	end
end

