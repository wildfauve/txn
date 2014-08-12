class MonthRange
  include Enumerable

  def initialize(range)
    @start_date = range.first
    @end_date   = range.last
    @start_date = Date.parse(@start_date) unless @start_date.respond_to? :month
    @end_date   = Date.parse(@end_date) unless @end_date.respond_to? :month
  end

  def each
    current_month = @start_date
    while current_month <= @end_date do
      yield current_month
      current_month = (current_month + 1.month)
    end
  end
end