class KpiDailyReport
  attr_accessor :tags, :date
  def initialize(date)
    @date = date
    @tags = ["Network", "Sales", "Sending", "Performance" ]
  end

  def results_for_tag(tag)
    Kpi.results_for_tag_and_date(tag, @date)
  end


end
