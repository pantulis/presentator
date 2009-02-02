require 'find'
require 'fileutils'

def create_thumbs_dir(path)
  puts "create_thumbs_dir #{path}"
  unless File.exists?(path + '/thumbs')
    FileUtils.mkdir(path + '/thumbs')
  end
end

def eval_dir(path)
  puts "eval_dir (#{path})"
  create_thumbs_dir(path)

  lista = []
  Find.find(path) do |path|
    unless FileTest.directory?(path)
      lista << eval_file(path)
    else
      if File.basename(path) == 'thumbs'
        Find.prune
      else
        next
      end
    end
  end
  lista
end


class MyImage
  attr_accessor :url
  attr_accessor :thumbnail_url
end

def eval_file(path)
  
  image = MyImage.new

  if File.exists?("thumbs/#{path}")
    image.thumbnail_url = "thumbs/#{path}"
  else
    thumbnail_path = File.dirname(path) + '/thumbs/' + File.basename(path) 
    puts "Generar thumbnail para #{path} en #{thumbnail_path}"
    
    ImageScience.with_image(path) do |img|
      img.resize(200, img.height * (200.to_f / img.width)) do |thumb|
        thumb.save(thumbnail_path)
      end
    end

    image.thumbnail_url = thumbnail_path.gsub('public/','')
  end
  image.url = path.gsub('public/', '')    
  image
end
  
