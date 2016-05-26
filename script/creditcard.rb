require "active_merchant/billing/rails" # had to require this as per the command line feedback, since activemerchant has deprecated valid? method

credit_card = ActiveMerchant::Billing::CreditCard.new(
  number: '4111111111111111',
  month: '10',
  year: '2016',
  first_name: 'Mike',
  last_name: 'Jones',
  verification_value: '271'
  )

puts "Is #{credit_card.number} valid? #{credit_card.valid?}"