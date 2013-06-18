module BookingsHelper

  def paypal_button_for(booking)
    merchant_id = ENV["PAYPAL_MERCHANT_ID"]
    script_path = asset_path("vendor/paypal-button.min.js") + "?merchant=#{merchant_id}"
    content_tag :script, "", { src: script_path }.merge(paypal_params_for(booking))
  end

  def paypal_params_for(booking)
    address = if (addr = booking.renter.address).present?
      {
        "data-address1" => addr.address_line_1,
        "data-address2" => addr.address_line_2,
        "data-zip"      => addr.postal_code,
        "data-city"     => addr.city,
        "data-state"    => addr.state
      }
    else {} end

    sandbox = if true # for now; Rails.env.development?
      { "data-env" => "sandbox" }
    else {} end

    address.merge(sandbox).merge(
      "data-button" => "buynow",
      "data-name"   => booking.display_name,
      "data-email"  => booking.renter.email,
      "data-quantity" => 1,
      "data-amount" => booking.price,
      "data-currency" => "USD",
      "data-callback" => paid_booking_url(booking),
      "data-first_name" => booking.renter.first_name,
      "data-last_name" => booking.renter.last_name
    )
  end

end
