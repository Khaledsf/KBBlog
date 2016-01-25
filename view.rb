#!/usr/bin/ruby

require 'cgi'
require 'erb'
require 'sqlite3'

@cgi = CGI.new

if @cgi.cookies['username'].size > 0
	@userName = @cgi.cookies['username'][0]
else
	puts @cgi.header("status" => 302, "location" => "login.rb")
end

db = SQLite3::Database.new('./login.db')
db.execute "CREATE TABLE IF NOT EXISTS Users(Uid INTEGER PRIMARY KEY  AUTOINCREMENT, Username TEXT, Email TEXT, Password TEXT)"
db.execute "CREATE TABLE IF NOT EXISTS Articles(Aid INTEGER PRIMARY KEY  AUTOINCREMENT, Uid INTEGER, Article TEXT)"
db.execute "CREATE TABLE IF NOT EXISTS Comments(Cid INTEGER PRIMARY KEY  AUTOINCREMENT, Uid INTEGER, Aid INTEGER, Comment TEXT)"

def query_data
	db = SQLite3::Database.new('./login.db')
	userCommentById = db.execute "SELECT Uid, Comment FROM Comments"
	username = db.execute "SELECT Username FROM Users"
	
	userCommentById.each do |array|
		id = array.shift
		user = db.execute "SELECT Username FROM Users WHERE Uid=#{id}"
		user.flatten!
		array.unshift(user[0])
	end
	userCommentById
end

render = File.read("./view.html.erb")
output = ERB.new(render)
@cgi.out { output.result() }