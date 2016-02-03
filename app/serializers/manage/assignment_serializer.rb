class Manage::AssignmentSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :assigned_to, :ticket_id, :accepted_at, :completed_at
end
