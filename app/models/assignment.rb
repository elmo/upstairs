class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignee, class_name: 'User', foreign_key: 'assigned_to'
  belongs_to :ticket
  validates_presence_of :ticket
  validates_presence_of :user
  validates_presence_of :assignee

  scope :completed, lambda { where.not(completed_at: nil ) }
  scope :open, lambda { where(completed_at: nil) }
  scope :assigned_to_user, lambda  { |user| where(assigned_to: user.id )}
  scope :accepted, lambda  { |user| where.not(accepted_at: nil )}
  scope :waiting_for_claiming, lambda  { |user| where(accepted_at: nil )}
  scope :for_building, lambda { |building| joins(:ticket).where( tickets: {building_id: building.id} ) }

  def complete!
    update_attributes(completed_at: Time.now)
  end

  def reopen!
    update_attributes(completed_at: nil)
  end

  def accept!
    update_attributes(accepted_at: Time.now)
  end

  def relinquish!
    update_attributes(accepted_at: nil)
  end

  def completed?
    completed_at.present?
  end

  def accepted?
    accepted_at.present?
  end


end
