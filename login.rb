#!/usr/bin/ruby
require 'cgi'
require 'sqlite3'
require 'erb'

@cgi = CGI.new
@cookie = nil

def login
	#puts cgi.header("status" => 302, "location" => "login.html")
	render = File.read("./login.html.erb")
	output = ERB.new(render)
	#puts @cgi.header
	puts @cgi.out { output.result(); }
end

def view(userName)
	cookie = CGI::Cookie.new('name' => 'username',
                         'value' => userName,
                         'expires' => Time.now + 3600)
	puts @cgi.header("status" => 302, "cookie" => cookie, "location" => "view.rb")
end

if @cgi.request_method == "GET"
	if @cgi.cookies["username"].size > 0
		#File.write('/tmp/debug', "Username #{@session['user_name']} is logged in\n", mode: 'a')
		view(@cgi.cookies["username"][0])
	else
		login
	end
end

db = SQLite3::Database.new('login.db')

userEmail = @cgi['user_login']
userPass = @cgi['user_pass']
userName = ""
data = db.execute("SELECT * FROM Users WHERE Email = '#{userEmail}' LIMIT 1;")

if data.length == 1
	if data[0][3] == userPass
		userNameData = db.execute("SELECT Username FROM Users WHERE Email = '#{userEmail}';")
		userName = userNameData[0][0]
    view(userName)
  else
  	login
  end
end