#Install on clean Ubuntu

##Install Passenger and Nginx
Guide from: https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html

```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
sudo apt-get install apt-transport-https ca-certificates
```

Create a file /etc/apt/sources.list.d/passenger.list and insert one of the following lines, depending on your distribution.

```
# Ubuntu 14.04
deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main
```

```
#Secure passenger.list and update your APT cache:
sudo chown root: /etc/apt/sources.list.d/passenger.list
sudo chmod 600 /etc/apt/sources.list.d/passenger.list
sudo apt-get update

#install nginx and passenger
sudo apt-get install nginx-extras passenger

#Edit /etc/nginx/nginx.conf and uncomment passenger_root and passenger_ruby

#install Ruby with RVM https://rvm.io/rvm/install
sudo apt-get install curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby
curl -sSL https://get.rvm.io | bash -s stable --rails

#install project
sudo apt-get install git
git clone https://github.com/hypertornado/diplomka.git stock_photo_finder
cd stock_photo_finder
bundle install

RAILS_ENV=production bundle exec rake db:migrate

#get rvm ruby path for nginx
which passenger-config
/usr/bin/passenger-config --ruby-command
#> To use in Nginx : passenger_ruby /home/odchazel/.rvm/gems/ruby-2.2.0/wrappers/ruby

#nginx configuration (delete content of sites-enabled)
server {
        listen 80 default_server;
        server_name  _;
        passenger_enabled on;
        root /webs/stock_photo_finder/public;
}

passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
passenger_ruby /home/odchazel/.rvm/gems/ruby-2.2.0/wrappers/ruby

#Stop apache2 if necessary
sudo service apache2 stop

#restart nginx
sudo service nginx restart

#download elasticsearch-1.4.4 into /webs/stock_photo_finder/bin

#start elasticsearch
nohup /webs/stock_photo_finder/bin/elasticsearch-1.4.4/bin/elasticsearch &

#import data
bundle exec rake es:import_word_data
bundle exec rake es:import_image_metadata

#thats all
#server sould be running at http://quest.ms.mff.cuni.cz:3380/


```

