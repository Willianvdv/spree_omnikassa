Deface::Override.new(:virtual_path => "spree/shared/_order_details",
                     :name => "add_omnikassa_payment_method_method_to_order_details",
                     :insert_bottom => '.payment-info',
                     :text => '<% @order.payments.each do |payment| %>
                                <%= payment.payment_method.name %>
                              <% end %>')
