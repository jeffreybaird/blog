puts "what is the title of your new post?"

title = gets.chomp

template = title.gsub(" ", "_").downcase.strip + ".erb"

template_string =<<EOF
<%
# title:: #{title}%
# description::%
# date::#{Time.now.strftime("%Y,%m,%d")}%
# author:: Jeffrey Baird%
%>

<ul style="list-style:none;"><li><%= link_to("/", "Home") %></li><li><%= link_to("/blog", "Blog") %></li></ul>
EOF

File.open("views/posts/#{template.strip}", "w+") { |file| file.write(template_string)  }

