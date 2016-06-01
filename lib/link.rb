class LinkItem
  include Listable
  attr_reader :description, :site_name

  def initialize(url, options={})
    @description = url
    @site_name = options[:site_name]
  end

  #Includes formatted item data in an array for further manipulations (for example table style display)
  def details
    %W(#{format_type} 
       #{format_description(@description)} 
       site\ name:\ #{format_name(@site_name)})
  end
end
