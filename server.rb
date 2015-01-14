require 'sinatra/base'
require 'data_mapper'


class BookmarkManager < Sinatra::Base

	env = ENV['RACK_ENV'] || 'development'
	DataMapper.setup(:default, "postgres://localhost:5432/bookmark_manager_#{env}")

	require './lib/link'
  require './lib/tag'

	DataMapper.finalize
	DataMapper.auto_upgrade!
  # TODO:
  # Steph: please change DataMapper.auto_upgrade! to
  # DataMapper.auto_migrate! and then back to DataMapper.auto_upgrade!
  # in case you're getting the error "" again Failure/Error: expect(link.tags.map(&:text)).to include "education"
  # expected [] to include "education"

  # this is for outputting information for debugging purposes
  DataMapper::Logger.new($stdout, :debug)

  get '/' do
    @links = Link.all
    erb :index
  end

  post '/links' do
    url = params[:url]
    title = params[:title]
    tags = params[:tags].split(' ').map do |tag|
      Tag.first_or_create(text: tag)
    end
    Link.create(url: url, title: title, tags: tags)
   
    redirect '/'
  end

  get '/tags/:text' do
    tag = Tag.first(text: params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
