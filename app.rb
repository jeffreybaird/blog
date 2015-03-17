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
      erb :index
    end

    Dir["views/posts/**"].map{|x| File.basename(x,".erb")}.each do |post|
      puts post
      get "/posts/#{post.to_s}" do
        erb :"posts/#{post}"
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

      def posts
        Dir["views/posts/**"].map{|file_name| Post.new(file_name)}.sort_by{|post| post.date }.reverse
      end

      def prettify_post(post)
        post.gsub("_", " ").upcase
      end

    end

  end
end
