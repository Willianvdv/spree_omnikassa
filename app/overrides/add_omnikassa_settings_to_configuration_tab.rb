Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "add_omnikassa_settings_to_configuration_menu",
                     :insert_bottom => '[data-hook="admin_configurations_sidebar_menu"]',
                     :text => '<%= configurations_sidebar_menu_item t(:omnikassa_settings), admin_omnikassa_settings_path %>')
