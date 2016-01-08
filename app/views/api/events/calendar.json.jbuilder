json.array! @events do |event|
  json.id event.id
  json.title event.title
  json.allDay false
  json.start event.starts.to_time.iso8601
  json.end(event.starts + 2.hours).to_time.iso8601
  json.url building_event_url(@building, event)
  json.className "calendarEvent" 
  json.editable false
  json.startEditable false
  json.durationEditable false
  json.overlap false
  json.constraint nil
  json.source nil
  json.color "black" 
  json.backgroundColor "green" 
  json.borderColor "black" 
  json.texrtColor "white" 
end
