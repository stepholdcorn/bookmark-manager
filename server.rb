require 'sinatra/base'
require 'data_mapper'

class BookmarkManager < Sinatra::Base

	env = ENV['RACK_ENV'] || 'development'
	DataMapper.setup(:default, "postgres://localhost:5432/bookmark_manager_#{env}")

	require './lib/link'

	DataMapper.finalize
	DataMapper.auto_upgrade!

  # this is for outputting information for debugging purposes
  DataMapper::Logger.new($stdout, :debug)

  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params[:url]
    title = params[:title]
    Link.create(url: url, title: title)
    redirect '/'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
