require 'sinatra/base'
require 'data_mapper'

class BookmarkManager < Sinatra::Base

	env = ENV['RACK_ENV'] || 'development'
	DataMapper.setup(:default, "postgres://localhost:5432/bookmark_manager_#{env}")

	require './lib/link'

	DataMapper.finalize
	DataMapper.auto_upgrade!

  get '/' do
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
