# Magickman

MagickMan is a Rails front-end manager for ImageMagick or any scriptable image processor.
The installation of ImageMagick varies between platforms, please 
consult the documentation for your platform.

## Installation

Add this line to your application's Gemfile:

    gem 'magickman', :git => "git@github.com:mdykman/magickman.git"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install magickman-{version}.gem
	 	=> install magickman library

	$ rails generate magickman [prefix] [resource_path]
		=> defaults: /magick, /public/images
		=> generate initializer to define the route, manually define styles (default: small, medium, large)
		=> controller to handle the requests
		
Once the generator has been run and the server restarted, you may review available configuration 
types at http://mydevhost/:port/magickman/manage

## Usage

### templates :
Once installed, on-demand image processing can take place by using the special
helper tag: 'magick_tag'. It use is very similar to the standard 'image_tag' with 
the exception that it takes a 'format' argument. 

  <%= magick_tag "magickman.jpg", :medium  %>
  
  can be used wherever the following would work
  
  <%= image_tag "magickman.jpg" %>

magick_tag uses image_tag for the actual rendering and therefore supports all the options 
that image_tag does.

### image generation
New images are generated at the instigation of the magickman controller after it has searched 
the resource paths for the requested image, always preferring to reuse existing images rather than 
generate new ones. If the requested images is not found, it tests the file name against
expected format names.  If is determined to be a 'derivable' image, it searches image 
resource paths for a potential source image.  If one is found, the appropriate 
transformation is applied and the resulitng image served.  That same image will be reused 
on subsequent requests.

Under the default configuration, all newly created files are put in public/.


### formats

Formats are specified in config/initializers/magickman.rb which should be
created with the generator at instllation.  They may be edited to provide 
a variety of custom formats according to your needs.

#### defaults formats 
    :thumb =>  '-resize 100x100\>',
    :small =>  '-resize 400x400\>',
    :medium => '-resize 600x600\>',
    :large =>  '-resize 800x800\>'


Formats are divided into 2 classes:  format string which begin with '-' are evaluated
as option string to be passed to the imagemagick 'convert' program.  This is a powerful 
program which serves a wide variety of cases in a single command. 

 $ convert $formatstring $sourceimg $targetimg

For a format string :large =>"-resize 800x800\>", requesting image 'foo.large.jpg', the command will be

  $ convert -resize 800x800\> assets/images/foo.jpg public/foo.large.jpg

assuming that foo.jpg has been located in assets/images/

When the format string does not begin with '-', it is assumed to be a custom command.
For a format string :watermark =>"/usr/local/bin/watermark.rb"

 $ /usr/local/bin/watermark.rb assets/images/foo.jpg public/foo.large.jpg

#### custom scripts
Custom scripts can be in any language.  They should take input and output files from the command line 
arguments, and exit with 0 upon success for maximum compatability. It is expected that the output image 
has been created or at least exists before a custom script signals successful termination.

### not-found handling
  magickman allows a custom not-found image on a per-type basis, via config[:notfoundtypes].  
  It is assumed that files specified here have been pre-formatted according to their format
  type and therfore are not processed before serving.
  
  There is a fall back not-found image at config[:notfound] which will be processed according to
  the requested format upon request.  These configuration values may be updated via user values.
  The not-found image provided is intended to be a convenience, not a recommendation.
  
  THe status codes returned in a not found situation vary depending upon configuration.
  If no appropriate :notfoundtypes or :notfound image is configured, failure to find an
  image or a useable source with result in a Rails::RoutingError which delivers a 404.
  
  If a suitable not-found image can be found, the exact behaviour depends on the value of
  config[:strict].  When this is set to 'false' (the deault), a not-found event results 
  in a 303 redirect to the not-found resource.  This assures that the 'not-found' image
  will be displayed in every image-aware client.  When config[:strict] is true, a 404 is 
  issued with the not-found image in the body.  This will display properly on most clients,
  but some clients may choose to ignore the content of 404 responses on resource requests.
   
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
