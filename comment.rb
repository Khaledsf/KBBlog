#!/usr/bin/ruby
require 'cgi'
require 'sqlite3'

cgi = CGI.new

username = cgi['username']
comment = cgi['comment']

db = SQLite3::Database.new('login.db')
db.execute "CREATE TABLE IF NOT EXISTS Comments(Cid INTEGER PRIMARY KEY  AUTOINCREMENT, Uid INTEGER, Aid INTEGER, Comment TEXT)"

data = db.execute("SELECT * FROM Users WHERE Username = '#{username}' ")
uid = data[0][0]
userName = data[0][1]

db.execute "INSERT INTO Comments(Uid, Aid, Comment) VALUES (?, ?, ?)", [uid, 1, comment]

puts cgi.header("status" => 302, "location" => "view.rb?username=#{username}")