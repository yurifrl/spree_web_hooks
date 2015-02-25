class CreateNotificationTable < ActiveRecord::Migration
  def up
    unless table_exists? :spree_web_hooks_notifications
      create_table :spree_web_hooks_notifications do |t|
        t.integer :notifiable_id
        t.string :notifiable_type
        t.integer :event_id
        t.integer :status, default: 0
        t.integer :attempts, default: 0
        t.integer :max_attempts, default: 3

        # So a can always make the same call
        t.integer :hook_content_type, default: 0
        t.text :hook_address
        t.string :hook_event_name
        t.boolean :hook_send_data
        t.string :hook_secret
        t.timestamps
      end
      unless column_exists? :spree_web_hooks_logs, :notification_id
        add_column :spree_web_hooks_logs, :notification_id, :integer
      end
      unless column_exists? :spree_web_hooks_hooks, :max_attempts
        add_column :spree_web_hooks_hooks, :max_attempts, :integer, default: 3
      end
    end
  end
  def down
    if table_exists? :spree_web_hooks_notifications
      drop_table :spree_web_hooks_notifications
    end
    if column_exists? :spree_web_hooks_logs, :notification_id
      remove_column :spree_web_hooks_logs, :notification_id
    end
    if column_exists? :spree_web_hooks_hooks, :max_attempts
      remove_column :spree_web_hooks_hooks, :max_attempts
    end
  end
end
