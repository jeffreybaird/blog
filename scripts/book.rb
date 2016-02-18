puts "what is the book title?"

title = gets.chomp

puts "how many pages?"

pages = gets.chomp

puts "what is the authors name?"

author = gets.chomp

puts "What do you rate it out of 5?"

rating = gets.chomp

template = title.gsub(" ", "_").downcase.strip + ".erb"

template_string =<<EOF
<%
# title::#{title} %
# rating::#{rating}%
# description::#{rating}/5 stars:%
# date::#{Time.now.strftime("%Y,%m,%d")}%
# pages::#{pages}%
# author::#{author}%
%>

<h1><%= link_to("http://example.com",@book.title) %></h1>

<h4>by <%= @book.author %></h4>

<h3>Rating: <%= @book.rating %>/5 stars</h3>

<h3>Date completed: <%=  #{Time.now.strftime("%B %d, %Y") }%></h3>

<%= footer %>
EOF

File.open("views/books/#{template.strip}", "w+") { |file| file.write(template_string)  }
