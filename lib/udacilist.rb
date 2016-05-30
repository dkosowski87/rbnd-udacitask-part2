class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end

  def add(type, description, options={})
    type = type.downcase
    if ["todo", "event", "link"].include? type
      @items.push TodoItem.new(description, options) if type == "todo"
      @items.push EventItem.new(description, options) if type == "event"
      @items.push LinkItem.new(description, options) if type == "link"  
    else
      raise UdaciListErrors::InvalidItemType, "Invalid item type provided."
    end
  end

  def delete(index)
    if index > @items.length
      raise UdaciListErrors::IndexExceedsListSize , "Index exceeds the size of the list."
    else
      @items.delete_at(index - 1)
    end
  end
  
  def all
    @title ? list_heading : print_separator(15)
    print_items(@items)
  end

  def filter(type)
    @title ? list_heading : print_separator(15)
    selected_items = @items.select { |item| item.format_type.downcase.strip == type }
    raise UdaciListErrors::NoFoundItemsOfType, "There are no items of such type in the list." if selected_items.empty? 
    print_items(selected_items)
  end

  private
  def list_heading
    print_separator(@title.length)
    puts @title
    print_separator(@title.length)
  end

  def print_separator(length)
    puts "-" * length
  end

  def print_items(items)
    items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
