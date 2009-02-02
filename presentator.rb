require 'rubygems'
require 'sinatra'
require 'lib/array_extension'
require 'lib/thumbnailer'
require 'yaml'

require 'image_science'

get '/:project_name' do
  @thumbnails = eval_dir("public/projects/#{params[:project_name]}")
  @config = YAML::load(File.open("public/projects/config.yml"))
  erb :project
end
