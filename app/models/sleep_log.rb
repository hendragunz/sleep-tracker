class SleepLog < ApplicationRecord
  scope :longest_duration, -> { order(duration: :desc) }
  scope :latest, -> { order(created_at: :desc)}

  belongs_to :user

  before_save :calc_duration

  def sleep?
    sleep_at.present? && wakeup_at.blank?
  end

  def wakeup?
    wakeup_at.present?
  end

  private

  def calc_duration
    if sleep_at.present? && wakeup_at.present?
      self.duration = (wakeup_at - sleep_at).to_i
    end
  end
end
