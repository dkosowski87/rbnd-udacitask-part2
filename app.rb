require 'chronic'
require 'colorize'
require 'terminal-table'
require 'highline'
require 'date'
require_relative "lib/listable"
require_relative "lib/errors"
require_relative "lib/udacilist"
require_relative "lib/todo"
require_relative "lib/event"
require_relative "lib/link"
require_relative "lib/user"
require_relative "lib/interface"

# list = UdaciList.new(title: "Julia's Stuff")
# list.add("todo", "Buy more cat food", due: "2016-02-03", priority: "low")
# list.add("todo", "Sweep floors", due: "2016-01-30")
# list.add("todo", "Buy groceries", priority: "high")
# list.add("event", "Birthday Party", start_date: "2016-05-08")
# list.add("event", "Vacation", start_date: "2016-05-28", end_date: "2016-05-31")
# list.add("link", "https://github.com", site_name: "GitHub Homepage")
# list.all
# list.delete(3)
# list.all

# SHOULD CREATE AN UNTITLED LIST AND ADD ITEMS TO IT
# --------------------------------------------------
# new_list = UdaciList.new # Should create a list called "Untitled List"
# new_list.add("todo", "Buy more dog food", due: "in 5 weeks", priority: "medium")
# new_list.add("todo", "Go dancing", due: "in 2 hours")
# new_list.add("todo", "Buy groceries", priority: "high")
# new_list.add("event", "Birthday Party", start_date: "May 31")
# new_list.add("event", "Vacation", start_date: "Dec 20", end_date: "Dec 30")
# new_list.add("event", "Life happens")
# new_list.add("link", "https://www.udacity.com/", site_name: "Udacity Homepage")
# new_list.add("link", "http://ruby-doc.org")

# SHOULD RETURN ERROR MESSAGES
# ----------------------------
# new_list.add("image", "http://ruby-doc.org") # Throws InvalidItemType error
# new_list.delete(9) # Throws an IndexExceedsListSize error
# new_list.add("todo", "Hack some portals", priority: "super high") # throws an InvalidPriorityValue error

# DISPLAY UNTITLED LIST
# ---------------------
# new_list.all

# DEMO FILTER BY ITEM TYPE
# ------------------------
# new_list.filter("event")

# USERS FEATURE
# ---------------------
# user = User.new("Mike", "udacity")
# puts user.name

# puts User.find_by_name("Mike").name == "Mike" #should return true
# # user = User.new("Mike", "udacity") #should return NotUniqueUser "User with that name already exists."
# # user = User.new("John", "udaci") #should return NotValidPassword "The password should be at least 7 characters long."

# puts user.authenticate('udacity') #should return true
# # puts user.authenticate('wrong') #should raise AuthenticationFailure "Invalid password."

# user.create_list(title: "Concert")
# user.print_lists # should return 1. Concert
# user.create_list(title: "Work")
# user.print_lists # should return 1. Concert, 2. Work

# list1 = user.find_list(1)
# puts list1.title #should return Concert
# list2 = user.find_list_by_title("Work")
# puts list2.title #should_retur Work

#INTERFACE FEATURE
# ---------------------
user = User.new("Mike", "udacity")
user.create_list(title: "Groceries")
user.create_list(title: "Concert")
Interface.new.start