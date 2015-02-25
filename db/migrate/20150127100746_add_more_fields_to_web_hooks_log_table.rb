class AddMoreFieldsToWebHooksLogTable < ActiveRecord::Migration
  def up
    unless column_exists? :spree_web_hooks_logs, :msg
      add_column :spree_web_hooks_logs, :msg, :text
    end
    if column_exists? :spree_web_hooks_logs, :response
      change_column :spree_web_hooks_logs, :response, :text
    end
  end
  def down
    if column_exists? :spree_web_hooks_logs, :msg
      remove_column :spree_web_hooks_logs, :msg
    end
    if column_exists? :spree_web_hooks_logs, :response
      change_column :spree_web_hooks_logs, :response, :string
    end
  end
end