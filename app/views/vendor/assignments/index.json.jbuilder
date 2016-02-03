json.array!(@manage_assignments) do |manage_assignment|
  json.extract! manage_assignment, :id, :user_id, :assigned_to, :ticket_id, :accepted_at, :completed_at
  json.url manage_assignment_url(manage_assignment, format: :json)
end
