Deface::Override.new(
    :virtual_path => "spree/admin/shared/sub_menu/_plugins",
    :name => "web_hooks_admin_tab",
    :insert_bottom => "[data-hook='admin_plugins_sub_tabs']",
    :text => '<%= tab :web_hooks, :match_path => "/admin/web_hooks", label: "#{Spree.t(:web_hooks)}" %>'
)