class ChangeAlertBodyMax < ActiveRecord::Migration
  def change
    change_column(:alerts, :message, :text, limit: 160)
  end
end
