class CreateWebHooksEventTable < ActiveRecord::Migration
  def up
    unless table_exists? :spree_web_hooks_events
      create_table :spree_web_hooks_events do |t|
        t.string :name
        t.timestamps
      end
    end
    [{name: 'order_create'},
     {name: 'order_update'},
     {name: 'order_destroy'},
     {name: 'product_create'},
     {name: 'product_update'},
     {name: 'product_destroy'},
     {name: 'payment_create'},
     {name: 'payment_update'},
     {name: 'payment_destroy'},
     {name: 'user_create'},
     {name: 'user_update'},
     {name: 'user_destroy'},
    # {name: 'order_payment'},
    # {name: 'order_cancel'},
    # {name: 'order_fulfillment'},
    # {name: 'cart_create'},
    # {name: 'cart_update'},
    # {name: 'collection_create'},
    # {name: 'collection_update'},
    # {name: 'collection_destroy'},
    # {name: 'customer_group'},
    # {name: 'customer_group'},
    # {name: 'customer_group'},
    # {name: 'checkout_create'},
    # {name: 'checkout_update'},
    # {name: 'checkout_destroy'},
    # {name: 'fulfillment_create'},
    # {name: 'fulfillment_update'},
    # {name: 'customer_enable'},
    # {name: 'customer_disable'},
    # {name: 'shop_update'},
    # {name: 'refund_create'}
    ].each do |e|
      Spree::WebHooks::Event.where(e).first_or_create
    end
  end

  def down
    if table_exists? :spree_web_hooks_events
      drop_table :spree_web_hooks_events
    end
  end
end