class User
	attr_reader :name, :lists

	@@users = []

	def initialize(name, password)
		@name = name
		@password = password
		@lists = []
		validate_password
		add_to_users
	end

	#Finds a user by name, returns nil if no user found
	def self.find_by_name(name)
		user = @@users.find { |user| user.name.downcase == name.downcase }
	end

	#Finds a user by name, raises error if no user found.
	def self.find_by_name!(name)
		user = User.find_by_name(name)
		!user ? raise(UdaciListErrors::NoUserFound, "No user found with name: #{name}.") : user
	end

	def authenticate(password)
		if password == @password
			true
		else
			raise UdaciListErrors::AuthenticationFailure, "Invalid password."
		end
	end

	#Creates a list, returns the created list.
	def create_list(options={})
		list = UdaciList.new(options)
		@lists << list
		return list
	end

	def print_lists
		rows = []
		@lists.each_with_index do |list, position|
      rows << ["#{position + 1}", list.title]
    end
    puts Terminal::Table.new rows: rows, title: "UdaciLists - #{name}", headings: %w(No. Title)
	end

	def find_list(id)
		@lists[id - 1]
	end

	def find_list_by_title(title)
		@lists.find { |list| list.title == title }
	end

	private
	def add_to_users
		if User.find_by_name(name)
			raise UdaciListErrors::NotUniqueUser, "User with name: '#{name}' already exists."
		else
			@@users << self
		end
	end

	def validate_password
		if @password.length < 7
			raise UdaciListErrors::NotValidPassword, "The password should be at least 7 characters long."
		end
	end
end