# Monittr #

Monittr provides a Ruby interface for the [Monit](http://mmonit.com/monit/) systems management system. Its main goal is to aggregate statistics from multiple Monit instances and display them in an attractive web interface.

Monittr loads XML from the [web server embedded in Monit](http://mmonit.com/monit/documentation/monit.html#monit_httpd) and makes it accessible as Ruby objects. It also provides helpers for [Sinatra](http://www.sinatrarb.com/) applications, to display the information as HTML. You can insert the statistics into any page, or create a dedicated one. You can use the default template, or create your own. The default template is located in `lib/monittr/sinatra/template.erb` and pictured below.

![Screenshot: Monittr, a web interface for Monit statistics](https://github.com/karmi/monittr/raw/master/screenshot.png)


## Usage ##

First, clone or [download](https://github.com/karmi/monittr/zipball/master)
the sources from [Github](https://github.com/karmi/monittr/), to get the latest version:

    $ git clone http://github.com/karmi/monittr.git
    $ cd monittr

You can try the Ruby interface in a IRB console:

    $ irb -Ilib -rubygems -rmonittr

You have to pass one or more URLs to a local or remote Monit [HTTP server](http://mmonit.com/monit/documentation/monit.html#monit_httpd):

    cluster = Monittr::Cluster.new ['http://localhost:2812/']

In case you don't have a running Monit server at hand, use the provided FakeWeb setup:

    require 'fakeweb'
    FakeWeb.register_uri(:get, 'http://localhost:2812/_status?format=xml', :body => File.read('test/fixtures/status.xml') ); nil

    cluster = Monittr::Cluster.new ['http://localhost:2812/']

Now, you can display the information from the cluster:

    cluster.servers.size

    server = cluster.servers.first
    server.system.status
    server.system.load

    server.filesystems.first.name
    server.filesystems.first.percent

    server.processes.first.name
    server.processes.first.cpu
    server.processes.first.memory

    ...

You can also check out the HTML display by running the example application:

    $ ruby examples/application.rb
    $ open http://localhost:4567/

You should see the information about two faked Monit instances in your browser. (You may need to comment out the FakeWeb section, if you're passing `localhost` URLs.)

To use the gem in your application, you have to require the Sinatra helper and provide the URLs to Monit instances:

    require 'monittr/sinatra/monittr'
    set :monit_urls,  %w[ http://production.example.com:2812 http://staging.example.com:2812 ]

In a “classic” Sinatra application, you have to register the module explicitely as well:

    register Sinatra::MonittrHTML

Then, just call the helper in your template:

    <%= monittr.html %>

Use may use the example application as the starting point.


## Customization ##

It's easy to customize the HTML output by setting the appropriate options in your Sinatra application.

    set :template,   Proc.new { File.join(root, 'template.erb') }
    set :stylesheet, '/path/to/my/stylesheet'


## Installation ##

The best way to install the gem is from the source:

    $ git clone http://github.com/karmi/monittr.git
    $ cd monittr
    $ rake install

Stable versions of the gem can be installed from Rubygems:

    $ gem install monittr


## Other ##

Any feedback, suggestions or patches are welcome via [e-mail](mailto:karmi@karmi.cz) or Github Issues/Pull Requests.

Check out the [`monit`](https://github.com/k33l0r/monit) gem for another Ruby interface to _Monit_.

-----

[Karel Minarik](http://karmi.cz)
