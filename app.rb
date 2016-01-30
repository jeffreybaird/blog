require 'bundler'
require 'rss'
Bundler.require

Dir.glob('./lib/*.rb') do |model|
  require model
end

module Jeff
  class App < Sinatra::Application

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
      post = File.basename(file_name,".erb")
      get "/blog/posts/#{post.to_s}" do
        @post = Post.new(file_name)
        erb :"posts/#{post}"
      end
    end

    Dir["views/books/**"].map do |file_name|
      book = File.basename(file_name,".erb")
      get "/books/#{book.to_s}" do
        @book = Book.new(file_name)
        erb :"books/#{book}"
      end
    end

    #helpers
    helpers do
      def partial(file_name)
        erb file_name, :layout => false
      end

      def link_to(url,text=url,opts={})
        attributes = ""
        opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
        "<a href=\"#{url}\" #{attributes}>#{text}</a>"
      end

      def footer
        f = "<div class='pure-menu pure-menu-horizontal'><ul class='pure-menu-list'>"
        footer_links.each do |l|
          f << "<li class='pure-menu-item'>#{l}</li>"
        end
        f + "</ul></div>"
      end

      def footer_links
        [home,blog,public_key,books_link]
      end

      def home
        link_to('/', 'Home',{class: 'pure-menu-link'})
      end

      def blog
        link_to('/blog', 'Blog',{class: 'pure-menu-link'})
      end

      def public_key
        link_to('/public_key', 'My Public Key',{class: 'pure-menu-link'})
      end

      def books_link
        link_to('/books', 'Books',{class: 'pure-menu-link'})
      end

      def posts
        @posts ||= Dir["views/posts/**"].map{|file_name| Post.new(file_name)}.sort_by{|post| post.date }.reverse
      end

      def books
        @books ||= Dir["views/books/**"].map{|file_name| Book.new(file_name)}.sort_by{|book| book.rating }.reverse
      end

      def prettify_post(post)
        post.gsub("_", " ").upcase
      end

      def rss
        @rss = RSS::Maker.make("atom") do |maker|
          maker.channel.author = "Jeffrey Baird"
          maker.channel.updated = posts[0].date
          maker.channel.about = "http://www.jeffreyleebaird.com/blog.rss"
          maker.channel.title = "Jeffrey Baird's Blog"
          maker.channel.icon = "http://www.jeffreyleebaird.com/img/favicon.png"

          (posts + books).sort_by{|x| x.date}.reverse.each do |post|
            maker.items.new_item do |item|
              item.link = "http://www.jeffreyleebaird.com/blog/posts/#{post.internal_link}"
              item.description = post.description
              item.title = post.title
              item.updated = post.date
            end
          end
        end
      end

    end

  end
end
