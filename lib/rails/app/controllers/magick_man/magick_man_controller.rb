#require 'magickman'

module MagickMan
class MagickManController  < ApplicationController
  
  def initialize 
  end

  def serve
    # remove the first component
#    filepath= :imgpath.to_s
    filepath= "#{params[:imgpath]}.#{params[:format]}"
    puts "loading from req path #{filepath}"
    
puts "#{__FILE__} #{__LINE__}"
    mm = MagickManager.instance
puts "#{__FILE__} #{__LINE__}"

    if not mm.supportsType? params[:format]
      puts "unsupported type requested: #{filepath}"
      redirect_to filepath, status: 302
		return
    end
	 puts "#{__FILE__} #{__LINE__}"
    
    if not File.exists? filepath
	 puts "#{__FILE__} #{__LINE__}"
      src = mm.findsource filepath
	 puts "#{__FILE__} #{__LINE__}"
      if src
	 puts "#{__FILE__} #{__LINE__}"
        rr = mm.convert src
		  puts "convert returns #{rr}"
	 puts "#{__FILE__} #{__LINE__}"
#       else 
#         raise ActionController::RoutingError.new("Source Not Found for #{src[:path]}")
      end
    end
    
	 puts "#{__FILE__} #{__LINE__}"
    if File.exists? filepath
	 puts "#{__FILE__} #{__LINE__}"
      expires_in 30.days, public => true
	 puts "#{__FILE__} #{__LINE__}"
      send_file filepath, :disposition => params[:attachment] ?  'attachment' : 'inline'
		return
	 puts "#{__FILE__} #{__LINE__}"
    else
      # let the regular resource server report the error
	 puts "#{__FILE__} #{__LINE__}"
      redirect_to filepath, status: 301
		return
	 puts "#{__FILE__} #{__LINE__}"
#       raise ActionController::RoutingError.new('Not Found')
    end
	 puts "#{__FILE__} #{__LINE__}"
  end  # e[nd of serve
end

end
