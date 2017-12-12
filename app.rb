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
  if current_user
    redirect '/show'
  else
    erb :index
  end
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

get '/deleteaccount' do
  authenticate_user
  @user.destroy
  redirect '/'
end

post '/login' do
  user = User.find_or_create_by(username: params[:username])
  session[:user_id] = user.id
  redirect "/show"
end

post '/show' do
  authenticate_user
  @user.posts.create(text: howlify(params[:text])) 
  redirect '/show'
end

patch '/info' do
  authenticate_user
  current_user.update(location: params[:location], age: params[:age], petpeeves: params[:petpeeves])
  redirect '/account'
end

get '/account/:id' do
  authenticate_user
  @other_user = User.find_by_id(params[:id])
  erb :'other_users/account'
end

def howlify(input)
  output = input.upcase

  replacements = {
    "CANNOT" => "CAN",
    "CAN'T" => "CAN",
    "WON'T" => "WILL",
    "NOT" => '',
    "COULDN'T" => "COULD",
    "SHOULDN'T" => "SHOULD",
    "WOULDN'T" => "WOULD",
    "ISN'T" => "IS",
    "AREN'T" => "ARE",
    "DOES" => "DOESN'T",
    "DO" => "DON'T",

    "CAN" => "CAN'T",
    "WILL" => "WON'T",
    "COULD"=> "COULDN'T",
    "SHOULD" => "SHOULDN'T",
    "WOULD" => "WOULDN'T",
    "IS" => "ISN'T",
    "ARE" => "AREN'T",
    "DOESN'T" => "DOES",
    "DON'T" => "DO"
  }


  output = output.split(' ')
  output = output.map do |e|
    replacements.fetch(e, e)
  end

  output.delete('')
  output = output.join(' ')

  output.gsub! "I ", "THIS FILTH "
  output.gsub! "I'M", "THIS FILTH ISN'T"
  output.gsub! "I'LL", "THIS FILTH WON'T"
  output.gsub! "THE ", "THE GODDAMN "
  output.gsub! "A ", "A FREAKING "
  output.gsub! "TO ", "TO DISGUSTINGLY "

  index = (rand() * 10).to_i
  topicalArray = ["THANKS OBAMA, ", "GODDAMIT! ", "FOR THE LAST TIME, ", "WHY DOESN'T ANYONE REALIZE THAT ", "JESUS, ", "THE NEW WORLD ORDER! ", "THAT'S WHAT'S WRONG WITH THIS COUNTRY- ", "THIS IS THE LAST THING I NEED, ", "MY PARENTS NEVER LOVED ME, THAT'S WHY ", "NOOOOOOO, ", "YOU KNOW WHAT GRINDS MY GEARS - "]

  output.gsub! '.', '!!!'
  return topicalArray[index] + output + "!!!"
end
