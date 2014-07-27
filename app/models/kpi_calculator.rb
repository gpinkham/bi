# Responsible for calculating a kpi for a date
class KpiCalculator
  def initialize(kpi, date)
    @kpi = kpi
    @date = date
  end

  def current_result
    @kpi.result_for_date(@date)
  end

  def calculate!
    if current_result.nil?
      add_result!
    else
      recalculate_result!
    end
    save_percent_change!
  end

  def add_result!
    result = sql_result
    create_result!(result) unless result.nil?
  end

  def create_result!(result)
      KpiResult.create!({
        :date               => result["date"],
        :today              => result["today"],
        :t7days             => result["t7days"],
        :t30days            => result["t30days"],
        :qtd                => result["qtd"],
        :ytd                => result["ytd"],
        :kpi_id             => @kpi.id
      })
  end

  def sql_result
    results = @kpi.query_connection.execute(build_sql)
    puts results.inspect
    results.first
  end

  def recalculate_result!
    kpi_result = sql_result
    current_result.update_attributes!(
      :today              => kpi_result["today"],
      :t7days             => kpi_result["t7days"],
      :t30days            => kpi_result["t30days"],
      :qtd                => kpi_result["qtd"],
      :ytd                => kpi_result["ytd"]
    ) unless kpi_result.nil?
  end

  def save_percent_change!
    result = current_result
    last_week = @kpi.result_for_date(@date - 7.days)
    last_month = @kpi.result_for_date(@date - 30.days)

    changes = percent_change_hash(result, last_week, last_month)
    result.update_attributes!(changes) unless result.nil?
  end

  def build_sql
    date = @date.strftime("%m/%d/%Y")

    kpi_date = Time.strptime(date,"%m/%d/%Y").strftime("%Y-%m-%d")
    end_date = Time.strptime(date,"%m/%d/%Y") + 1.days + 4.hours

    today_start      = end_date - 1.days
    seven_day_start  = end_date - 7.days
    thirty_day_start = end_date - 30.days
    quarter_start    = today_start.beginning_of_quarter + 4.hours
    year_start       = today_start.beginning_of_year + 4.hours
    start_date       = (year_start > thirty_day_start) ? thirty_day_start : year_start

    ERB.new(@kpi.query).result(binding)
  end

  private

  def percent_change_hash(result, last_week, last_month)
    return unless result.present?

    changes = {}
    changes.merge!(
      { :today_pct_change   => percent_change(result.today, last_week.today),
        :t7days_pct_change  => percent_change(result.t7days, last_week.t7days) }
    ) unless last_week.nil?

    changes.merge!(
      {:t30days_pct_change => percent_change(result.t30days, last_month.t30days)}
    ) unless last_month.nil?

    changes
  end

  def percent_change(new, old)
    return unless old.present? && new.present? && old != 0 && new != 0
    ((new / old.to_f - 1) * 100).round(2)
  end

end
