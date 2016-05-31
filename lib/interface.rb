class Interface

	#APP START

	def start
		@operator = HighLine.new
		@operator.say "Welcome to UdaciTask. The best place to store and schedule your stuff.".colorize(:yellow)
		@operator.choose do |menu|
			menu.choice(:register) { register }
  		menu.choice(:login) { login }
		end
	end

	private

	#USER

	def register
		name = @operator.ask "Provide a username.".colorize(:yellow)
		password = @operator.ask "Provide a password".colorize(:yellow)
		@user = User.new(name, password)
		user_menu
	end

	def login
		name = @operator.ask "Enter your username.".colorize(:yellow)
		password = @operator.ask "Enter your password.".colorize(:yellow)
		@user = User.find_by_name(name)
		if @user && @user.authenticate(password)
			user_menu
		else
			raise UdaciListErrors::FailedLogin, "There was a problem with the credentials, check the username and password again"
		end
	end

	def user_menu
		@operator.say "Hello #{@user.name}! What would you like to do today?".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("Create a new list") { create_list_menu }
  		menu.choice("Show all my lists") { display_all_user_lists }
  		menu.choice("Exit app")
		end
	end

	#CREATING LISTS

	def create_list_menu
		title = @operator.ask "Provid a title for the list.".colorize(:yellow)
		list = @user.create_list(title: title)
		@operator.say "Would you like to add some items to the list?".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("Yes") { list_items_menu(list) }
  		menu.choice("No") { user_menu }
		end
	end

	#SHOWING LISTS

	def display_all_user_lists
		@user.print_lists
		@operator.say "Should we take a closer look at any of the lists?".colorize(:yellow)
		@operator.choose do |menu|
  		@user.lists.each do |list|
  			menu.choice("Show #{list.title}") {  display_user_list(list) }
  		end
  		menu.choice("Back to main menu") { user_menu }
		end
	end

	def display_user_list(list)
		list.all
		@operator.say "Should we change anything?".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("Add items to list") { list_items_menu(list) }
  		menu.choice("Delete items from list") { delete_list_item(list) }
  		menu.choice("Back to lists") { display_all_user_lists } 
		end
	end

	#ADDING LIST ITEMS

	def list_items_menu(list)
		@operator.say "What should we add?".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("Todo") { todo_item_menu(list) }
  		menu.choice("Event") { event_item_menu(list) }
  		menu.choice("Link") { link_item_menu(list) } 
		end
	end

	def after_item_add_menu(list)
		@operator.say "Anything else?".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("Add another item") { list_items_menu(list) }
  		menu.choice("Back to list") { display_user_list(list) } 
		end
	end

	#DELETING LIST ITEMS

	def delete_list_item(list)
		index = @operator.ask "Which position from the list should we delete.".colorize(:yellow)
		list.delete(index.to_i)
		display_user_list(list)
	end

	#TODO ITEMS

	def todo_item_menu(list)
		description = @operator.ask "Add a description.".colorize(:yellow)
		due_date = select_item_date("Add a due date(optional, press enter to skip).")
  	priority = todo_item_priority_menu 
		list.add("todo", description, due: due_date, priority: priority)
		after_item_add_menu(list)
	end

	def todo_item_priority_menu
		@operator.say "Add priority (optional):".colorize(:yellow)
		@operator.choose do |menu|
  		menu.choice("high") { "high" }
  		menu.choice("medium") { "medium" } 
  		menu.choice("low") { "low" }
  		menu.choice("skip priority") { nil }
		end
	end

	#EVENTS

	def event_item_menu(list)
		description = @operator.ask "Add a description.".colorize(:yellow)
		start_date = select_item_date("Add a start date(optional, press enter to skip).")
		end_date = select_item_date ("Add a end date(optional, press enter to skip).")
		list.add("event", description, start_date: start_date, end_date: end_date)
		after_item_add_menu(list)
	end

	#LINKS

	def link_item_menu(list)
		description = @operator.ask "Add a description.".colorize(:yellow)
		site_name = @operator.ask "Add a site_name(optional, press enter to skip).".colorize(:yellow)
		site_name = site_name.strip.empty? ? nil : site_name
		list.add("link", description, site_name: site_name)
		after_item_add_menu(list)
	end

	#SHARED METHODS

	def select_item_date(message)
		date = @operator.ask message.colorize(:yellow)
		date.strip.empty? ? nil : date
	end

end