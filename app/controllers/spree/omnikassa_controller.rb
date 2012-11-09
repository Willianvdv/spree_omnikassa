module Spree
  class OmnikassaController < Spree::BaseController
    ssl_required

    def start
      # Start an omnikassa transaction
      @order = current_order
    end

    def success
    end

    def success_automatic
      # An automatic omnikassa response
    end

    def error
    end

  end
end
