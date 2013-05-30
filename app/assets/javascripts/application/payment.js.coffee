$ ->
  $("form.payment").each () ->
    form = $(this)
    key = form.data("braintree-client-key")
    braintree = Braintree.create(key)
    braintree.onSubmitEncryptForm(this)

    form.find("input.cc-number").payment("formatCardNumber")
    form.find("input.cc-cvv").payment("formatCardCVC")
    form.find("input.cc-expiration").payment("formatCardExpiry")
