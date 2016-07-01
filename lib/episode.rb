class Episode
  attr_reader :link, :title, :date

  def initialize(link, title, date)
    @link = link
    @title = title
    @date = DateTime.parse(date)
  end
end
