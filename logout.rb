#!/usr/bin/ruby
require 'cgi'

@cgi = CGI.new

if @cgi.request_method == "GET"
	if @cgi.cookies["username"].size > 0
		cookie = CGI::Cookie.new('name' => 'username',
                         'value' => '',
                         'expires' => Time.now - 3600)
		puts @cgi.header("status" => 302, "cookie" => cookie, "location" => "login.rb")
	end
end