class AddSsCodeToCities < ActiveRecord::Migration
  def up
    add_column :cities, :code, :string
  end

  def down
    remove_column :cities, :code
  end
end
