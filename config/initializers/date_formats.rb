Time::DATE_FORMATS[:published] = '%B %e, %Y'
Time::DATE_FORMATS[:event_date] = '%B %e'
Time::DATE_FORMATS[:comment] = '%B %e, %Y at %l:%M%p'

class Time
  
  def am_pm
    hour < 12 ? 'AM' : 'PM'
  end
end

class DateTime
  
  def to_i
    to_time.to_i
  end
  
end
