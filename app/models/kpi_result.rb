class KpiResult < ActiveRecord::Base
#  attr_accessible :date, :name, :event_type, :partner, :today, :t7days, :t30days, :today_pct_change, :t7days_pct_change, :t30days_pct_change, :qtd, :ytd, :kpi_id

  belongs_to :kpi



  def humanize(column)
    val = self.send(column)
    return "?" unless val

    if column.to_s =~ /pct_change/
      "#{val.round(2)}%"
    elsif val.round == val
      val.round.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    else
      val.round(2).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    end
  end

  def stat_increased?(stat)
    val = self.send(stat)
    val.present? && val > 0
  end

  def as_json(options = {})
    super(options).merge({'name' => kpi.name })
  end

end
