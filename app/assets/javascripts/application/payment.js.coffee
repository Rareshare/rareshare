$ ->
  $("form.payment").each () ->
    form = $(this)
    submitBtn = form.find("input[type=submit]")
    Stripe.setPublishableKey form.data("stripe-key")

    number = form.find("input[data-stripe='number']")
    cvc    = form.find("input[data-stripe='cvc']")
    exp    = form.find("input[data-stripe='exp']")

    number.payment 'formatCardNumber'
    cvc.payment 'formatCardCVC'
    exp.payment 'formatCardExpiry'

    formToStripe = () ->
      expiry = exp.payment('cardExpiryVal')

      number: number.val(),
      cvc: cvc.val(),
      exp_month: expiry.month,
      exp_year: expiry.year

    form.submit (evt) ->
      evt.preventDefault()
      submitBtn.attr("disabled", "disabled")

      form.find("p.help-block").remove()
      form.find(".control-group").removeClass("error")

      Stripe.createToken formToStripe(), (status, response) ->
        console.log response
        if (error = response.error)?
          if error.param.match(/exp/)
            error.param = "exp"
            error.message = "You must provide a valid card expiration date."

          group = form.find("input[data-stripe=#{error.param}]").closest(".control-group")
          group.addClass("error")
          group.find(".controls").append $("<p>").addClass("help-block").text(error.message)
          submitBtn.removeAttr("disabled")
        else
          form.find("input[name='transaction[stripe_token]']").val response.id
          form.get(0).submit()

