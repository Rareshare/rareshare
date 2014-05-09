$("#edits").append("<%= escape_javascript(render 'form', booking: @booking_edit.booking, booking_edit: @booking_edit) %>")
$("#booking_edit_form").modal()