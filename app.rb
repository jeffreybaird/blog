require 'bundler'
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

    get '/public_key' do
      erb :public_key
    end

    get '/books' do
      erb :'books/index'
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
        f = "<ul style'list-style:none;'>"
        footer_links.each do |l|
          f << "<li>#{l}</li>"
        end
        f + "</ul>"
      end

      def footer_links
        [home,blog,public_key,books]
      end

      def home
        link_to('/', 'Home')
      end

      def blog
        link_to('/blog', 'Blog')
      end

      def public_key
        link_to('/public_key', 'My Public Key')
      end

      def books
        link_to('/books', 'Books')
      end

      def posts
        Dir["views/posts/**"].map{|file_name| Post.new(file_name)}.sort_by{|post| post.date }.reverse
      end

      def prettify_post(post)
        post.gsub("_", " ").upcase
      end

    end

  end
end
