#!/usr/bin/ruby
require 'cgi'
require 'sqlite3'
require 'erb'

cgi = CGI.new

db = SQLite3::Database.new('./login.db')
db.execute "CREATE TABLE IF NOT EXISTS Users(Uid INTEGER PRIMARY KEY  AUTOINCREMENT, Username TEXT, Email TEXT, Password TEXT)"

# Getting data from user input from login page(signup.html).
userName = cgi['user_name']
userEmail = cgi['user_email']
userPass = cgi['user_pass']
boolean = true

# Gettin data from the table then checking if whether a users exists or not.
data = db.execute("SELECT * FROM Users;")

i = 0
while i < data.length
	e = 1
	while e < data[i].length
		if userName == data[i][1] && data[i][2] == userEmail
			boolean = false
		else
			boolean
		end
		e += 1
	end
	i += 1
end

if boolean == true
	db.execute("INSERT INTO Users (Username, Email, Password) VALUES (?,?,?)", [userName, userEmail, userPass])
	puts cgi.header("status" => 302, "location" => "view.rb?username=#{userName}")
else
	puts cgi.header("status" => 302, "location" => "login.html")
end