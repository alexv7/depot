class OrderNotifier < ApplicationMailer
  default from: 'Yournamehere <itdoesntmatter@gmail.com>' #this does matter as we saw with group shalex
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.received.subject
  #
  def received(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_notifier.shipped.subject

  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  def cart_error_occured(error)
    @error = error
    # @error = ActiveRecord::RecordNotFound
    mail :to => "alexvarjabedian7@gmail.com", :subject => 'Depot App Error Incident'  ## replace your email id to receive mails
  end

  def product_error_occured
    mail :to => "alexvarjabedian7@gmail.com", :subject => 'Depot App Error Incident'  ## replace your email id to receive mails
  end

end
