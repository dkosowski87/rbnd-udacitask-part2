module Listable
	def format_description(description)
		"#{description}".ljust(30)
	end

	def format_date(*dates)
		dates = dates.map { |date| date.strftime("%D") if date }
		date_info = dates[0]
		date_info << " -- " + dates[1] if dates[1]
		date_info = "No due date" if dates.none? && dates.size == 1
		date_info = "N/A" if dates.none? && dates.size > 1
    return date_info
	end

	 def format_priority(priority)
    value = " ⇧".colorize(:red) if priority == "high"
    value = " ⇨".colorize(:orange) if priority == "medium"
    value = " ⇩".colorize(:yellow) if priority == "low"
    value = "" if !priority
    return value
  end
end