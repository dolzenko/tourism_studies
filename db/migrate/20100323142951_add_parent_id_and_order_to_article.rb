class AddParentIdAndOrderToArticle < ActiveRecord::Migration
  def self.up
    change_table :articles do |t|
      t.belongs_to :parent
      t.integer :position, :default => 0
    end
  end

  def self.down
  end
end
