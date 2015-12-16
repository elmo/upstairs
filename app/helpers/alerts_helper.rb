module AlertsHelper

  def recent_alerts
    render partial: '/alerts/recent' if @building.alerts.recent.any?
  end

end
