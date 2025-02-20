class_name Clock

# Sample string: 2025-02-20T14:01:30
static func new_date(date_string: String) -> ClockDate:
  var clock_date: ClockDate = ClockDate.new()
  clock_date.set_date_and_time(date_string)
  return clock_date

static func time_between_dates(d1: ClockDate, d2: ClockDate) -> ClockTime:
  var day_diff: float = d1.month_day - d2.month_day
  var hour_diff: float = day_diff*24 - (d1.time.hours - d2.time.hours)
  var minute_diff: float = hour_diff*60 - (d1.time.minutes - d2.time.minutes)
  var second_diff: float = abs(minute_diff*60 - (d1.time.seconds - d2.time.seconds))
  
  var time = ClockTime.new()
  time.hours = floor(second_diff / 3600)
  time.minutes = floor((second_diff - time.hours*3600) / 60)
  time.seconds = (second_diff - time.hours*3600 - time.minutes*60)
  return time
  
static func get_date_now() -> ClockDate:
  return ClockDate.new()

static func time_from_now(date: ClockDate) -> ClockTime:
  return Clock.time_between_dates(Clock.get_date_now(), date)
