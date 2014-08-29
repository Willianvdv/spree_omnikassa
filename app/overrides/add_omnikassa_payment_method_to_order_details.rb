# Deface::Override.new(:virtual_path => "spree/shared/_order_details",
#                      :name => "add_omnikassa_payment_method_method_to_order_details",
#                      :insert_bottom => '.payment-info',
#                      :text => '<% if @order.payment_method.class == Spree::PaymentMethod::Omnikassa %>
#                                   <%= @order.payment_method.name %>
#                                <% end %>')
