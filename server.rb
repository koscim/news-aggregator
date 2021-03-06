require 'sinatra'
require 'csv'
require 'uri'

set :bind, '0.0.0.0'  # bind to all interfaces

configure :development, :test do
  require 'pry'
end
get '/' do
  "<h1>The News Aggregator Homepage<h1>" + "<h2><a href='/articles'>Articles</a></h2>"
end

get '/articles' do
  # @arr_of_arrs = CSV.read("articles.csv")
  @articles = CSV.read("articles.csv", headers: true, header_converters: :symbol)
  erb :articles
end

get '/articles/new' do
  erb :article_new
end

post '/articles/new' do
  @article_title = params[:title]
  @article_url = params[:url]
  @article_description = params[:description]
  uri = URI.parse(@article_url)
  plagiarized = false
  articles = CSV.read("articles.csv", headers: true, header_converters: :symbol)
  articles.each do |article|
    if article[:url] == @article_url
      plagiarized = true
    end
  end
  if params[:title].empty? || params[:url].empty? || params[:description].empty?
    @error = "Error! Must include title, URL, and description"
    erb :error
  elsif uri.scheme != "http" && uri.scheme != "https"
    @error = "Error! URL must include http"
    erb :error
  elsif params[:description].length < 20
    @error = "Error! Description must be longer than 20 characters"
    erb :error
  elsif plagiarized == true
    @error = "Error! That article has already been submitted"
    erb :error
  else
    CSV.open("articles.csv", "ab") do |csv|
      csv << [@article_title, @article_url, @article_description]
    end
    redirect '/articles'
  end
end
