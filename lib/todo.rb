class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    if ["high", "medium", "low", nil].include? options[:priority]
      @description = description
      @due = options[:due] ? Date.parse(options[:due]) : options[:due]
      @priority = options[:priority]  
    else
      raise UdaciListErrors::InvalidPriorityValue, "Invalid priority value passed."
    end
  end
  
  def details
    format_description(@description) + "due: " +
    format_date(@due) +
    format_priority(@priority)
  end
end
