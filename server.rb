require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash

	require './lib/link'
  require './lib/tag'
  require './lib/user'
  require_relative 'data_mapper_setup'

  # this outputs info: debugging purposes
  # DataMapper::Logger.new($stdout, :debug)

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

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email], 
      password: params[:password],
      password_confirmation: params[:password_confirmation])
    if @user.save 
      session[:user_id] = @user.id
      redirect '/'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'/users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end
    
  # end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
