require 'bundler'
require 'rss'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Jeff
  class App < Sinatra::Application

    helpers ApplicationHelpers

    #configure
    configure do
      set :root, File.dirname(__FILE__)
      set :public_folder, 'public'
    end


    #filters

    #routes
    get '/' do
      erb :"about/me"
    end

    get '/blog' do
      erb :blog
    end

    get '/blog.rss' do
      content_type 'text/xml'
      rss.to_xml
    end

    get '/public_key' do
      erb :public_key
    end

    get '/books' do
      erb :'book'
    end

    get '/books/rating' do
      erb :'rating'
    end


    Dir["views/posts/**"].map do |file_name|
      post_name = File.basename(file_name,".erb")
      get "/blog/posts/#{post_name.to_s}" do
        post = Post.new(file_name)
        erb :"posts/#{post_name}", :locals => { :post => post }
      end
    end

    Dir["views/books/**"].map do |file_name|
      book_name = File.basename(file_name,".erb")
      get "/books/#{book_name.to_s}" do
        book = Book.new(file_name)
        erb :"books/#{book_name}", :locals => { :book => book }
      end
    end


  end
end
