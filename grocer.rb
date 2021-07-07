require 'pry'

def consolidate_cart(cart)
h = {}
count = cart.each_with_object(Hash.new(0)){ |word,counts| counts[word] += 1 }
count.each {|item, frequency|
  item.each {|k,v|
  if v.has_key?(:count)
    v[:count] = v[:count]*frequency
  else
    v[:count] = frequency
  end
  h.store(k, v)}}
  cart = h
return cart
end

def apply_coupons(cart, coupons)
h = {}
  cart.each {|item, info|
    coupons.each do |deal|
        if deal[:item] == item && info[:count] >= deal[:num]
          info[:count] = info[:count] - deal[:num]
        if h["#{item} W/COUPON"]
            h["#{item} W/COUPON"][:count] += 1
          else
          h["#{item} W/COUPON"] = {price: deal[:cost], clearance: cart[item][:clearance], count: 1}
          end
        end
      end
  }
  cart.merge!(h)
return cart
end


def apply_clearance(cart)
  cart.each{|item, info|
    if info[:clearance] == true
      cart[item][:price] = (cart[item][:price]*0.8).round(2)
    end}
end

def checkout(cart, coupons)
  total = 0
  cart = cart.each{|item|
          item.each {|k,v|
            if v[:count] == 0
              cart.delete(item)
            end
      }
    }
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart.each {|item, info|
      total = total + (info[:price]*info[:count])}
  if total > 100
    total = total*0.9
  end
  return total
end
