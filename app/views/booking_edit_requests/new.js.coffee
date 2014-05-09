$("#edit_requests").append("<%= escape_javascript(render 'form', booking: @booking, booking_edit_request: @booking_edit_request) %>")
$("#booking_edit_request_form").modal()