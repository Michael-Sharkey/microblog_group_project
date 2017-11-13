require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models'

require 'pry'

enable :sessions
# Database configuration
set :database, "sqlite3:development.sqlite3"

def current_user
  @user ||= User.find_by_id(session[:user_id])
end

def authenticate_user
  redirect '/' if current_user.nil?
end

# Define routes below
get '/' do
  erb :index
end

get '/account' do
  authenticate_user
  erb :account
end

get '/show' do
  authenticate_user
  erb :show
end

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  user = User.find_or_create_by(username: params[:username])
  session[:user_id] = user.id
  redirect "/show"
end

post '/show' do
  authenticate_user
  @user.posts.create(text: params[:text])
  redirect '/show'
end

# nots currently working
patch '/location' do
  authenticate_user
  current_user.update(location: params[:location])
  redirect '/account'
end

# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
