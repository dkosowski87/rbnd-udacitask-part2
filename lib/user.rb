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

	def find_by_name(name)
		@@users.find { |user| user.name == name }
	end

	def authenticate(password)
		if password == @password
			true
		else
			raise UdaciListErrors::AuthenticationFailure, "Invalid password."
		end
	end

	def create_list(options={})
		@lists.push UdaciList.new(options)
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
		if find_by_name(name)
			raise UdaciListErrors::NotUniqueUser, "User with that name already exists."
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