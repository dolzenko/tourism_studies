SLIDESHOW_RMAGICK_GEOMETRY = "693>"

require "RMagick"
require "pathname"
require "fileutils"

def resize_image(source, target, size)
  puts "#{ source } => #{ target}"
  img = Magick::Image.read(source).first

  # lifted from attachment_fu\processors\rmagick_processor.rb
  if size.is_a?(String) && size =~ /^c.*$/ # Image cropping - example geometry string: c75x75
    dimensions = size[1..size.size].split("x")
    img.crop_resized!(dimensions[0].to_i, dimensions[1].to_i)
  else
    img.change_geometry(size.to_s) { |cols, rows, image| image.resize!(cols<1 ? 1 : cols, rows<1 ? 1 : rows) }
  end

  File.open(target, 'w') do |f|
    f.binmode
    f.write img.to_blob
    f.close
  end
end

root = Pathname.new(File.expand_path("../", File.dirname(__FILE__)))

for source in Dir[(root + "db/models/articles/54-moskva/slideshow/source/*.*").to_s]
  target =  source.sub("slideshow/source", "slideshow/resized")
  FileUtils.mkdir_p(File.dirname(target))
  resize_image(source,target , SLIDESHOW_RMAGICK_GEOMETRY)
end