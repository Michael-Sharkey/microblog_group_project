require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models'

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
  erb :account
end

get '/show' do
  erb :show
end

get '/logout' do
  session.clear
  redirect '/'
end

post '/login' do
  username = params[:username].downcase
  user = User.find_or_create_by(username: username)
  session[:user_id] = user.id
  redirect "/show"
end



# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
