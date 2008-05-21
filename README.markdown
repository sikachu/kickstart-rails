# Useful Rails template that we're going to use for starting our applications

So in order to create a new project, we first check out the kickstart template:

    git clone --o kickstart git@github.com:code/kickstart-rails.git project_name

Then initialize and update Rails submodule from Github (Edge Rails)

    git submodule init
    git submodule update
    
Also, don't forget to create your own database.yml file, or rails would report some problem

    cp config/database.example.yml config/database.yml

And then later, create a project on Github (or on somewhere else), make sure that you're the collaborator of that project. (On Github, just click on edit link and adds a collaborator there.) Then issue the command to add another origin such as:

    git remote add origin git@github.com:code/project_name.git
    
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
