require 'date'
puts "what is the book title?"

title = gets.chomp

puts "how many pages?"

pages = gets.chomp

puts "what is the authors name?"

author = gets.chomp

puts "What do you rate it out of 5?"

rating = gets.chomp

puts "What date did you finish it (Y-M-D)"

begin
date = DateTime.parse(gets.chomp)
rescue
puts "That didn't work. Please try again. Make sure the format is (Y-M-D)"
date = DateTime.parse(gets.chomp)
end

puts "What is the Amazon Link?"

link = gets.chomp

path = title.gsub(" ", "_").downcase.strip

template = path + ".erb"

image = path + ".jpg"

template_string =<<EOF
<%
# title::#{title} %
# rating::#{rating}%
# description::#{rating}/5 stars:%
# date::#{date.strftime("%Y,%m,%d")}%
# pages::#{pages}%
# author::#{author}%
# image:: /img/#{image}%
%>

<h1><%= link_to("#{link}",book.title) %></h1>

<h4>by <%= book.author %></h4>

<h3>Rating: <%= book.rating %>/5 stars</h3>

<h3>Date completed: <%= book.date %></h3>

<img class="book-cover" style="height:auto; width:auto; max-width:300px; max-height:300px;" src="<%= book.image %>" alt="" />


<%= footer %>
EOF

File.open("views/books/#{template.strip}", "w+") { |file| file.write(template_string)  }
