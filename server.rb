require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require 'rest_client'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash
  use Rack::MethodOverride

	require './lib/link'
  require './lib/tag'
  require './lib/user'
  require_relative 'data_mapper_setup'

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

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions/new' do

  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect '/'
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    flash[:notice] = "Goodbye!"
    session[:user_id] = nil
    redirect '/'
  end

  get '/users/reset_password/:token' do
    erb :'users/change_password'
  end

  get '/users/reset_password' do
    erb :'users/reset_password'
  end

  post '/users/reset_password' do
    @email = params[:email]
    User.send_password_recovery_email(@email)
    redirect '/'
  end

  get '/users/change_password' do
    erb :'/users/change_password'
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id]) if session[:user_id]
    end
  end
    
  run! if app_file == $0
end
