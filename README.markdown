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

#Stop apache2 if necessary
sudo service apache2 stop

#Restart Nginx
sudo service nginx restart

#install Ruby with RVM https://rvm.io/rvm/install
sudo apt-get install curl
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby
curl -sSL https://get.rvm.io | bash -s stable --rails

#install project
sudo apt-get install git
git clone https://github.com/hypertornado/diplomka.git stock_photo_finder
cd stock_photo_finder
gem install sqlite3
bundle install

#nginx configuration
server {
        listen 80 default_server;
        server_name  _;
        passenger_enabled on;
        root /webs/stock_photo_finder/public;
}

```
