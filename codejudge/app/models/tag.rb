class Tag < ApplicationRecord
  # belongs_to :problem_tag
  def self.options_for_select
    find_by_sql("SELECT id, tag FROM tags ORDER BY LOWER(tag)")
      .map { |tag| [tag.tag, tag.id] }
  end
end
