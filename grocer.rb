def consolidate_cart(cart)
  consolidated_cart = {}
  cart.each do |item|
  
    item.each do |item_name, details|
      consolidated_cart[item_name] = details
    end
  end
  counted = {}
  cart.each do |item|
    item.each do |item_name, details|
      counted[item_name] = cart.count(item)
    end
  end
  counted.each do |item, number|
    consolidated_cart.each do |item_name, details|
      details[:count] = counted[item_name]
    end
  end
  return consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    if cart[item_name]

      if coupon[:num] <= cart[item_name][:count]

        cart[item_name][:count] = cart[item_name][:count] - coupon[:num]
        if cart["#{item_name} W/COUPON"] == nil
          cart["#{item_name} W/COUPON"] = {
            :price => coupon[:cost],
            :clearance => cart[item_name][:clearance],
            :count => 1
            }
        else
          cart["#{item_name} W/COUPON"][:count] += 1
        end
        
      end
      
    end
  end
  return cart 
  
end

def apply_clearance(cart)
  cart.each do |item, data|
    if data[:clearance] == true
      data[:price] = (0.8 * data[:price]).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  prices_list = [] 
  cart_for_checkout = consolidate_cart(cart)
  apply_coupons(cart_for_checkout, coupons)
  apply_clearance(cart_for_checkout)
   
  total = 0  
  cart_for_checkout.each do |item_name, data|
    total += data[:price] * data[:count]
  end
  if total > 100 
    total = 0.9 * total
  end
  return total
end
