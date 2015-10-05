Setting up the instance:

https://www.digitalocean.com/community/tutorials/how-to-install-ruby-2-1-0-and-sinatra-on-ubuntu-13-with-rvm

Setting up the webserver:
https://www.digitalocean.com/community/tutorials/how-to-deploy-sinatra-based-ruby-web-applications-on-ubuntu-13

Deploying:
https://www.digitalocean.com/community/tutorials/how-to-set-up-automatic-deployment-with-git-with-a-vps

# If it goes down:

ssh in:
in the app directory:
unicorn -c unicorn.rb -D
service nginx restart