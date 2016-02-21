require_relative 'erb'

class Post

  attr_reader :erb_render, :file, :body
  include ApplicationHelpers

  def initialize(file)
    @file = file
    b = get_binding
    b.local_variable_set(:post, self)
    @erb_render = ERB.new(File.read(file))
    @body = erb_render.result(b)
  end

  def post_body

  end

  def path
    "blog/posts"
  end

  def internal_link
    File.basename(file,".erb")
  end

  def title
    meta_data["title"]
  end

  def description
    meta_data["description"]
  end

  def date_array
    meta_data["date"].split(',')
  end

  def date
    Time.new(date_array[0],date_array[1],date_array[2]).strftime("%Y-%m-%d")
  end

  def author
    meta_data["author"]
  end

  def meta_data
    @meta_data ||= digest_meta_data
  end

  def digest_meta_data
    meta_data_array = erb_render.src.scan(/(?<=\#)(.*?)(?=\%)/).map{|x| x.pop.strip.split("::")}.reject{|y| y.length != 2}
    meta_data_array.to_h
  end

end
