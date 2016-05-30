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
    puts "-" * @title.length
    puts @title
    puts "-" * @title.length
    @items.each_with_index do |item, position|
      puts "#{position + 1}) #{item.details}"
    end
  end
end
