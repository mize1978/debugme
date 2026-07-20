class DebugLog < ApplicationRecord
  self.table_name = "debug_logs"

  validates :input, presence: true, length: { maximum: 200 }

  def category
    return "UNKNOWN" unless output.present?
    output.match(/\[(\w+)\]/)&.captures&.first || "ERROR"
  end

  def error_type
    return "UnknownError" unless output.present?
    output.lines.second&.strip || ""
  end
end
