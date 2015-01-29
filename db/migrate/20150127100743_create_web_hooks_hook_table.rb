class CreateWebHooksHookTable < ActiveRecord::Migration
  def up
    unless table_exists? :spree_web_hooks_hooks
      create_table :spree_web_hooks_hooks do |t|
        t.boolean :send_data
        t.integer :event_id
        t.integer :content_type, default: 0
        t.string :address
        t.string :secret
        t.timestamps
      end
    end
  end
  def down
    if table_exists? :spree_web_hooks_hooks
      drop_table :spree_web_hooks_hooks
    end
  end
end