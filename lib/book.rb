require_relative 'erb'

class Book

  attr_reader :erb_render, :file, :body
  include ::ApplicationHelpers

  def initialize(file)
    @file = file
    b = get_binding
    b.local_variable_set(:book, self)
    @erb_render = ERB.new(File.read(file))
    @body = erb_render.result(b)
  end

  def path
    "books"
  end

  def image
    meta_data["image"]
  end


  def internal_link
    File.basename(file,".erb")
  end

  def title
    meta_data["title"]
  end

  def pages
    meta_data["pages"].to_i
  end

  def description
    meta_data["description"]
  end

  def rating
    r = meta_data["rating"].to_f
    if r.to_i == r
      r.to_i
    else
      r
    end
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
