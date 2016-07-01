require 'bundler'
require 'rss'
require 'date'
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

    get '/episodes.rss' do
      content_type 'text/xml'
      podcast.to_xml
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

    get '/sprite' do
      erb :'about/sprite'
    end

    get '/pong' do
      erb :'games/pong'
    end

    get '/breakout' do
      erb :'games/breakout'
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

    Dir["public/episodes/**"].map do |file_name|
      Mp3Info.open(file_name) do |mp3|
        link = "#{mp3.tag.album.downcase.gsub(" ", "_")}_#{mp3.tag.title.downcase.gsub(" ", "_")}"
        date = mp3.tag2.TXXX.match(/Pub(\S*)/)[1]
        title = "#{mp3.tag.album}: #{mp3.tag.title}"
        episode = Episode.new(link, title,date)
        get "/podcast/#{link}" do
          erb :"/podcast/show", :locals => {:episode => episode}
        end
      end
    end

    get "/podcast" do
      erb :"/podcast/index", :locals => {:episodes => episodes}
    end


  end
end
