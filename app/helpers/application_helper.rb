# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def format_time(time)
    if time >= 1.week.ago
      time_ago_in_words( time ) + " ago"
    elsif time.year == Time.now.year
      time.strftime('%b %d')
    else
      time.strftime('%b %d, %y')
    end
  end
  
end
