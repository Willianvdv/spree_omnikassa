#Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
#                     :name => "add_omnikassa_settings_to_configuration_menu",
#                     :insert_bottom => '[data-hook="admin_configurations_sidebar_menu"]',
#                     :text => '<%= configurations_sidebar_menu_item t(:omnikassa_settings), edit_admin_omnikassa_settings %>')

Deface::Override.new(:virtual_path => "spree/admin/configurations/index",
                     :name => "add_omnikassa_settings_to_configuration_index",
                     :insert_bottom => '[data-hook="admin_configurations_menu"]',
                     :text => '<tr>
                                 <td><%= link_to t(:omnikassa_settings), :edit_admin_omnikassa_settings %></td>
                                 <td><%= t(:omnikassa_settings) %></td>
                               </tr>')

