class SleepLog < ApplicationRecord
  scope :longest_duration, -> { order(duration: :desc) }

  before_save :calc_duration

  private

  def calc_duration
    if sleep_at.present? && wakeup_at.present?
      self.duration = (wakeup_at - sleep_at).to_i
    end
  end
end
