class CreateWebHooksLogTable < ActiveRecord::Migration
  def up
    unless table_exists? :spree_web_hooks_logs
      create_table :spree_web_hooks_logs do |t|
        t.integer :hook_id
        t.string :http_status
        t.text :response
        t.timestamps
      end
    end
  end
  def down
    if table_exists? :spree_web_hooks_logs
      drop_table :spree_web_hooks_logs
    end
  end
end