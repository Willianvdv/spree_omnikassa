module Spree
  module Admin
    class OmnikassaSettingsController < Spree::Admin::BaseController

      def edit
        @preferences_omnikassa = [:omnikassa_merchant_id,
                                  :omnikassa_secret_key,
                                  :omnikassa_key_version,
                                  :omnikassa_transaction_reference_prefix]

      end

      def update
        params.each do |name, value|
          next unless Spree::Config.has_preference? name
          Spree::Config[name] = value
        end
        flash[:success] = t(:successfully_updated, :resource => t(:general_settings))

        redirect_to edit_admin_omnikassa_settings_path
      end
    end
  end
end
