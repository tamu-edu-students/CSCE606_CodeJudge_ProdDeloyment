class DifficultyLevel < ApplicationRecord
  def self.options_for_select
    order("LOWER(level)").map { |e| [e.level, e.id] }
  end
end
