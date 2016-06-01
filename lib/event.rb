class EventItem
  include Listable
  attr_reader :description, :start_date, :end_date

  def initialize(description, options={})
    @description = description
    @start_date = Chronic.parse(options[:start_date]) if options[:start_date]
    @end_date = Chronic.parse(options[:end_date]) if options[:end_date]
  end
  
  #Includes formatted item data in an array for further manipulations (for example table style display)
  def details
    %W(#{format_type} 
       #{format_description(@description)} 
       event\ dates:\ #{format_date(@start_date, @end_date)})
  end
end
