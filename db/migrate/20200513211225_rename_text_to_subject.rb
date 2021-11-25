class RenameTextToSubject < ActiveRecord::Migration[6.0]
  def change
    rename_column :actions, :text, :subject
  end
end
