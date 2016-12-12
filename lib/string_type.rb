module StringType
	def to_time_readable(date)
    date_time = DateTime.parse(date)
    parse_date = Parse::Date.new(date_time)
  end
end