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
    if index > @items.size
      raise UdaciListErrors::IndexExceedsListSize , "Index exceeds the size of the list."
    else
      @items.delete_at(index - 1)
    end
  end
  
  def all
    print_list(@items)
  end

  def filter(item_type)
    print_list(filter_items(item_type))
  end

  private

  def filter_items(item_type)
    filtered_items = @items.select { |item| item.format_type.strip == item_type }
    if filtered_items.empty? 
      raise UdaciListErrors::NoFoundItemsOfType, "There are no items of type '#{item_type}' in the list."
    end
    return filtered_items
  end

  def print_list(items)
    list_heading
    list_items(items) 
  end

  def list_heading
    if @title
      puts "-" * @title.length
      puts @title
      puts "-" * @title.length
    else
      puts "-" * 15
    end
  end

  def list_items(items)
    items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
