class AddFieldsToWebHooksLogTable < ActiveRecord::Migration
  def up
    unless column_exists? :spree_web_hooks_logs, :event_name
      add_column :spree_web_hooks_logs, :event_name, :string
    end
    unless column_exists? :spree_web_hooks_logs, :hook_address
      add_column :spree_web_hooks_logs, :hook_address, :string
    end
    if column_exists? :spree_web_hooks_logs, :hook_id
      remove_column :spree_web_hooks_logs, :hook_id
    end
  end
  def down
    if column_exists? :spree_web_hooks_logs, :event_name
      remove_column :spree_web_hooks_logs, :event_name
    end
    if column_exists? :spree_web_hooks_logs, :hook_address
      remove_column :spree_web_hooks_logs, :hook_address
    end
    unless column_exists? :spree_web_hooks_logs, :hook_id
      add_column :spree_web_hooks_logs, :hook_id, :integer
    end
  end
end