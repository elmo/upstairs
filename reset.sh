dropdb upstairs
createdb upstairs
rake db:migrate
rake db:seed
redis-server --daemonize yes
rails s
