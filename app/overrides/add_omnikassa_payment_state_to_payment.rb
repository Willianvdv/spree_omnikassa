Deface::Override.new(:virtual_path => "spree/admin/payments/_list",
                     :name => "add_omnikassa_payment_state_to_payment_head",
                     :insert_bottom => '[data-hook="payments_header"]',
                     :text => '<th>Response code</th>')

Deface::Override.new(:virtual_path => "spree/admin/payments/_list",
                     :name => "add_omnikassa_payment_state_to_payment_body",
                     :insert_bottom => '[data-hook="payments_row"]',
                     :text => '<td><% if payment.payment_method.class == Spree::BillingIntegration::Omnikassa %><%= payment.omnikassa_payments.last.try(:omnikassa_response_code) %><% end %></td>')

