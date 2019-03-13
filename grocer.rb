def consolidate_cart(cart)
  cart.each_with_object({}) do |array_item, new_cart|
    array_item.each do |key,value|
      if new_cart.has_key?(key)
        new_cart[key][:count] += 1
      else
        new_cart[key] = value
        new_cart[key][:count] = 1
      end
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart[item] && cart[item][:count] >= coupon[:num]
      if cart["#{item} W/COUPON"]
        cart["#{item} W/COUPON"][:count] += 1
      else
        cart["#{item} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{item} W/COUPON"][:clearance] = cart[item][:clearance]
      end
      cart[item][:count] -= coupon[:num]
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance]
      value[:price] = (value[:price] * 0.8).round(2)
    end
  end
  cart
end

def total_cost(cart)
  total = 0
  cart.each do |item, properties|
    total += properties[:price] * properties[:count]
  end
  total
end

def checkout(cart, coupons)
  consolidate = consolidate_cart(cart)
  do_coupons = apply_coupons(consolidate, coupons)
  do_clearance = apply_clearance(do_coupons)
  total = total_cost(do_clearance)
  total > 100 ? (total * 0.9).round(2) : total
end
