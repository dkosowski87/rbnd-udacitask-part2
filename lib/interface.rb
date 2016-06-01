class Interface

	#APP START

	def start
		@operator = HighLine.new
		say "Welcome to UdaciTask. The best place to store and schedule your stuff."
		show_possible_actions "register" => :register, "login" => :login
	end

	private

	#USER

	def register
		name = ask "Provide a username."
		password = ask_with_hidden_input "Provide a password"
		@user = User.new(name, password)
		user_menu
	end

	def login
		name = ask "Enter your username."
		password = ask_with_hidden_input "Enter your password."
		@user = User.find_by_name!(name)
		@user.authenticate(password)
		user_menu
	end

	def user_menu
		say "Hello #{@user.name}! What would you like to do today?"
		show_possible_actions "Create a new list" => :create_list_menu, 
									 				"Show all my lists" => :display_lists_menu, 
									 				"Exit app" => nil
	end

	#CREATING LISTS

	def create_list_menu
		title = ask "Provid a title for the list."
		list = @user.create_list(title: title)
		say "Would you like to add some items to the list?"
		show_possible_actions "Yes" => [:list_items_menu, list], "No" => :user_menu
	end

	#SHOWING LISTS

	def display_lists_menu
		@user.print_lists
		say "Should we take a closer look at any of the lists?"
		list_options = @user.lists.map { |list| ["Show #{list.title}", [:list_menu, list]] }.to_h 
		list_options.merge!({"Back to main menu" => :user_menu})
		show_possible_actions list_options
	end

	def list_menu(list)
		list.all
		say "Should we change anything?"
		show_possible_actions "Add items to list" => [:list_items_menu, list], 
									 				"Delete items from list" => [:delete_list_item_menu, list], 
													"Back to lists" => :display_lists_menu
	end

	#ADDING LIST ITEMS

	def list_items_menu(list)
		say "What should we add?"
		show_possible_actions "Todo" => [:todo_item_menu, list], 
									 				"Event" => [:event_item_menu, list], 
									 			  "Link" => [:link_item_menu, list]
	end

	def after_item_add_menu(list)
		say "Anything else?"
		show_possible_actions "Add another item"=> [:list_items_menu, list], 
									 				"Back to list" => [:list_menu, list]
	end

	#DELETING LIST ITEMS

	def delete_list_item_menu(list)
		index = ask "Which position from the list should we delete."
		list.delete(index.to_i)
		list_menu(list)
	end

	#ITEMS OPTIONS

	def todo_item_menu(list)
		description = ask "Add a description."
		due_date = ask_with_default_value "Add a due date (optional, press enter to skip)."
  	priority = todo_item_priority_menu 
		list.add("todo", description, due: due_date, priority: priority)
		after_item_add_menu(list)
	end

	def todo_item_priority_menu
		say "Add priority (optional):"
		show_possible_values "high" => "high", 
									 			 "medium" => "medium", 
									 			 "low" => "low",
									 			 "skip priority" => nil
	end

	def event_item_menu(list)
		description = ask "Add a description."
		start_date = ask_with_default_value "Add a start date(optional, press enter to skip)."
		end_date = ask_with_default_value "Add a end date(optional, press enter to skip)."
		list.add("event", description, start_date: start_date, end_date: end_date)
		after_item_add_menu(list)
	end

	def link_item_menu(list)
		description = ask "Add a description."
		site_name = ask_with_default_value "Add a site_name(optional, press enter to skip)."
		list.add("link", description, site_name: site_name)
		after_item_add_menu(list)
	end

	#SHARED INTERFACE METHODS

	def say(message)
		@operator.say message.colorize(:yellow)
	end

	def ask(message)
		@operator.ask message.colorize(:yellow)
	end

	def ask_with_hidden_input(message)
		@operator.ask(message.colorize(:yellow)) { |char| char.echo = "x" }
	end

	def ask_with_default_value(message)
		date = @operator.ask(message.colorize(:yellow)) { |value| value.default = nil }
	end

	def show_possible_actions(options={})
		@operator.choose do |menu|
			options.each do |key, value|
				menu.choice(key) { send(*value) if value }
			end
		end
	end

	def show_possible_values(options={})
		@operator.choose do |menu|
			options.each do |key, value|
				menu.choice(key) { value }
			end
		end
	end
end