# Kick-start your new Rails project with this blank-slate application

  git clone --origin kickstart git://github.com/mislav/kickstart-rails.git project_name

Example of what you could to after that:

  cd project_name
  script/generate sexy_scaffold user name:string email:string last_login:datetime
  rake db:migrate
  script/server

Then visit [localhost:3000/users](http://localhost:3000/users).

## Preconfigured for:

* Rails 2.1
* HTML4 Strict
* RSpec
* Haml
* make_resourceful

Useful stuff:

* CSS reset in Sass
* application layout in Haml
* few application view helpers
* sexy_scaffold generator (RSpec + Haml + make_resourceful)

TODO:

* Simple JavaScript helpers in application.js
* Paperclip for attachments?
* spec'd out user authentication
