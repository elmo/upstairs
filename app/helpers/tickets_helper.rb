module TicketsHelper
  def ticket_severities
    [Ticket::SEVERITY_MINOR, Ticket::SEVERITY_SERIOUS, Ticket::SEVERITY_SEVERE]
  end

  def ticket_statuses
    [Ticket::STATUS_OPEN, Ticket::STATUS_CLOSED]
  end
end
