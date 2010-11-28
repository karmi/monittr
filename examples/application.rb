$LOAD_PATH.unshift( File.expand_path('../../lib', __FILE__) )

require 'rubygems'
require 'monittr'
require 'sinatra'
require 'fakeweb'

# --- Require the Sinatra extension -------------------------------------------
require 'monittr/sinatra/monittr'
# -----------------------------------------------------------------------------

# --- Comment these lines to enable loading data from http://localhost:2812 ---
FakeWeb.register_uri(:get, 'http://localhost:2812/_status?format=xml',
                     :body => File.read( File.expand_path('../../test/fixtures/status.xml', __FILE__)))
# -----------------------------------------------------------------------------

# --- Set URLs to your Monit instances here -----------------------------------
set :monit_urls,  %w[ http://localhost:2812 http://localhost:2812 ]
# -----------------------------------------------------------------------------

# --- Use your own template ---------------------------------------------------
# set :template,   Proc.new { File.join(root, 'template.erb') }
# -----------------------------------------------------------------------------

# --- Use your own stylesheet for the `stylesheet` helper ---------------------
# set :stylesheet, '/path/to/my/stylesheet'
# -----------------------------------------------------------------------------


get "/" do
  erb :index
end


__END__

@@ layout
<!DOCTYPE html>
<html>
<head>
  <title>Example Admin Application With Monittr</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <style>
    body     { color: #222; font-family: sans-serif; margin: 2em; }
    p        { margin: 0 0 0.5em 0; }
    #example { border: 4px solid #ccc; padding: 1em; margin: 1em 0 1em 0; }
  </style>
</head>
<body>
  <%= yield %>
</body>
</html>

@@ index

<p>This is your regular admin application created with <em>Sinatra</em>, having lots of features.</p>

<p>Now, you can embed the <em>Monittr</em> info anywhere by calling this helper method:</p>

<pre>monittr.html</pre>

<p>and you should see something like this:</p>

<div id="example">
<%= monittr.html %>
</div><!-- /monittr_example -->

<p>See, easy.</p>

<p>You can customize the template, of course, and set the path to it with:</p>

<pre>
set :template, '/path/to/my/template.erb'
</pre>
