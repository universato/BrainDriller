# frozen_string_literal: true

class AddImpressionCounts < ActiveRecord::Migration[6.1]
  def change
    add_column :drills, :impressions_count, :integer, default: 0
    # add_column :problems, :impressions_count, :integer, default: 0
  end
end
