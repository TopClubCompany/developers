module Admin::PlacesHelper

  def generate_week_days
    week_days_titles = %w|monday tuesday wednesday thursday friday saturday sunday|
    week_days_titles.map { |title| WeekDay.new(title: title)}
  end

end
