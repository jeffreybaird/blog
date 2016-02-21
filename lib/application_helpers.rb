module ApplicationHelpers

  def get_binding
    return binding()
  end

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

      (posts + books).sort_by{|x| x.date}.reverse.each do |entry|
        maker.items.new_item do |item|
          item.link = "http://www.jeffreyleebaird.com/#{entry.path}/#{entry.internal_link}"
          item.description = entry.description
          item.summary = entry.body
          item.title = entry.title
          item.updated = entry.date
        end
      end
    end
  end

end
