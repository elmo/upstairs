module EventsHelper

  def month_calendar_td_options
    ->(start_date, current_calendar_date) { {class: "calendar-date", data: {day: current_calendar_date}} }
  end

   def month_calendar_header_options
     ->(start_date) { content_tag :strong, "#{I18n.t("date.month_names")[start_date.month]} #{start_date.year}", class: "calendar-title" }
   end

   def month_calendar_previous_link
      ->(param, date_range)  { link_to raw("&laquo;"), { param => date_range.first.at_beginning_of_month }}
   end

   def month_calendar_next_link
      ->(param, date_range)  { link_to raw("&raquo;"), { param => date_range.last.at_beginning_of_month }}
   end


end