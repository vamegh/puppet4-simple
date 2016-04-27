## Requirements
- internet connection
- Vagrant
- VirtualBox
- ruby >= 2.0
- bundler ruby gem

## Run
- install all the requirements above
- run `bundle install`
- cd into the vagrant dir
- run `vagrant up simple`

vagrant up simple should grab all of the requirement. .

Inside the vagrant folder there is a file called hosts.yaml, this is what tells vagrant what sort of server to create.

Inside the Vagrantfile, there is this code block:

```
hosts = []
if File.exist?("hosts.yaml")
  hosts= YAML.load(File.read("hosts.yaml"), File::RDONLY)
end

```

This reads in the hosts.yaml and it automatically converts it into an array of hosts with all of the data about the host stored in a hash, which it then later loops through and builds out the actual box.

inside scripts there is a provision.sh, this is called by vagrant and does all of the various baselining stuff and calls puppet-librarian and puppet, puppet-librarian installs all of the required puppet modules from puppet-forge / github.

The actual puppet stuff is all stored in the code folder

inside code/ there is a hiera.yaml -- this configues the hierarchy


inside :  code/environments/production/Puppetfile this is the librarian config file.

All of the real puppet configuration is inside code/environments/production


## What it does:

It install hazelcast manager, going to:

http://simple.test:8080

should load the hazelcast web interface.

It also configures the firewall, configures nginx and a bunch of other stuff.





