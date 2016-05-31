class UdaciList
  attr_reader :title, :items

  def initialize(options={})
    @title = options[:title]
    @items = []
  end

  def add(type, description, options={})
    type = type.downcase
    if %w(todo event link).include? type
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
    puts Terminal::Table.new rows: list_items(items), 
                             title: @title, 
                             headings: %w(No. Type Description Other Priority)
  end

  def list_items(items)
    rows = []
    items.each_with_index do |item, position|
      rows << ["#{position + 1}", item.details].flatten
    end
    return rows
  end
end
