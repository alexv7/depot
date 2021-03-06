module ApplicationHelper
 def hidden_div_if(condition, attributes = {}, &block)
   if condition
   attributes["style"] = "display: none"
   end
   content_tag("div", attributes, &block)
 end

 def currency_to_locale(price)
    price = price * 1.3 if 'es' == I18n.locale.to_s
    number_to_currency (price)
 end

end

#this is what the code is essentially doing
=begin
<div id="cart"
<% if @cart.line_items.empty? %>
style="display: none"
<% end %>
>
<%= render(@cart) %>
</div>
=end
