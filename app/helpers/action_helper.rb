# frozen_string_literal: true

module ActionHelper
  def time_select_array
    [
      ['1 Minute', 1.minute.to_i / 60],
      ['2 Minutes', 2.minutes.to_i / 60],
      ['3 Minutes', 3.minutes.to_i / 60],
      ['4 Minutes', 4.minutes.to_i / 60],
      ['5 Minutes', 5.minutes.to_i / 60],
      ['10 Minutes', 10.minutes.to_i / 60],
      ['15 Minutes', 15.minutes.to_i / 60],
      ['20 Minutes', 20.minutes.to_i / 60],
      ['25 Minutes', 25.minutes.to_i / 60],
      ['30 Minutes', 30.minutes.to_i / 60],
      ['1 Hour', 1.hour.to_i / 60],
      ['2 Hours', 2.hours.to_i / 60],
      ['3 Hours', 3.hours.to_i / 60],
      ['4 Hours', 4.hours.to_i / 60],
      ['5 Hours', 5.hours.to_i / 60],
      ['6 Hours', 6.hours.to_i / 60],
      ['12 Hours', 12.hours.to_i / 60],
      ['1 Day', 1.day.to_i / 60],
      ['2 Days', 2.days.to_i / 60],
      ['3 Days', 3.days.to_i / 60],
      ['4 Days', 4.days.to_i / 60],
      ['5 Days', 5.days.to_i / 60],
      ['6 Days', 6.days.to_i / 60],
      ['7 Days', 7.days.to_i / 60],
      ['14 Days', 14.days.to_i / 60],
      ['30 Days', 30.days.to_i / 60],
    ]
  end
end
