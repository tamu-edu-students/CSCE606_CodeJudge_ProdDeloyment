
This project is the continuation of the Legacy Code Judge project which was created earlier in Fall 2022. 

Client : Ritchey

TA :  Mayukh RoyChowdhury.

#### Members of the project :

1) Praveen Kumar Maddikuntla
2) Nagarjuna Kolloju
3) Nachiket Umesh Naganure
4) Druva Kumar Gunda
5) Anmol Anand
6) Loksubhash Pulivarthi


#### Proposed New Functionalities for this semester :

1. Creation of global/group level ranking system.
2. Addition of multi topic system for problems.
3. Adding the level of difficulty to each problem (Easy| Medium| Hard)
4. Batch testcase upload case functionality will be added
5. Filter problems based on 
        I) difficulty 
        II)tags
        III)solved/unsolved


## Local Development (Without Docker Container):

This guide is primarily for Mac/Linux Machines to setup local development.

* After cloning this project on your local machine, install Ruby, Rails and postgresql with brew.
```
brew install ruby
gem install rails 
brew install postgresql@14
```
- Create master.key document in ./config/ path and paste the key text(contact one of the members)
- Now we need to configure the db and configure our app to connect to it.
    - Start postgresql server 
      ```
         brew services start postgresql
      ```
    - By default postgresql creates a role with your machine username and password. 
    - Install Datagrip from Jetbrains and connect to psql server with the machine username and password.
    - You should be able to see postgres as a database in datagrip.
    - If you are unable to do above step create a new role and database as follows.
      ```
      CREATE ROLE <username> LOGIN PASSWORD 'securePass1';
      CREATE DATABASE <dbname>;
      grant all privileges on database <dbname> to <username> ;
      ```
    - In ./config/database.yml comment out the database key value pair in development section. Add edit database value in default section to the database name created in above step. It shoudl something like this.
     ```
      database: postgres
      # username: <%= ENV['DATABASE_USER'] %>.  #Commented
      # password: <%= ENV['DATABASE_PASSWORD'] %> #Commented
      development:
      <<: *default
      # database: codejudge_dev
     ```
- Install Redis and configure it in ./config/cable.yml
    - Install redis and start the service 
      ```
         brew install redis
         brew services start redis
      ```
    - Configure the followinf in cable.yml
      ```
          # url: <%= ENV.fetch("REDIS_URL") { "redis://redis:6379/1" } %> # Comment original config line
            url: redis://localhost:6379/1
      ```
- Make sure the ruby version in gem file matches your local ruby version.
- Now install the gems and start the server.
```
bundle install
rails server
```
- Using datagrip you can add users and assign roles to use the credentials for login.

- Note => In some Apple Sillicon machines ruby might point to native executable.
    - Use `which ruby` to find the path
    - To update path if required
    - Some of the brew command or gem installs won't work, one work around is to use append `sudo` to the brew command or use `sudo su` mode.


