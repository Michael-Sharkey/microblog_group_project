require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'
require './models'

enable :sessions
# Database configuration
set :database, "sqlite3:development.sqlite3"

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

# Providing model information to the view
# requires an instance variable (prefixing with the '@' symbol)

# Example 'User' index route

# get '/users' do
#   @users = User.all
#   erb :users
# end
