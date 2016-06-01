class TodoItem
  include Listable
  attr_reader :description, :due, :priority

  def initialize(description, options={})
    if %w(high medium low).include?(options[:priority]) || !options[:priority]
      @description = description
      @due = options[:due] ? Chronic.parse(options[:due]) : options[:due]
      @priority = options[:priority]  
    else
      raise UdaciListErrors::InvalidPriorityValue, "Invalid priority value passed."
    end
  end
  
  #Includes formatted item data in an array for further manipulations (for example table style display)
  def details
    %W(#{format_type} 
       #{format_description(@description)} 
       due:\ #{format_date(@due)} 
       #{format_priority(@priority)})
  end
end
