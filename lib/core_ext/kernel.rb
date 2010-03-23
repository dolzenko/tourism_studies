module Kernel
  # Is self included in other?
  #
  #   5.in?(0..10)       #=> true
  #   5.in?([0,1,2,3])   #=> false
  #
  def in?(arrayish, *more)
    arrayish = more.unshift(arrayish) unless more.empty?
    arrayish.include?(self)
  end

  def arrayify(var = self)
    var.is_an?(Array) ? var : [var]
  end

  def r(*obj)
    obj = obj[0] if obj.is_a?(Array) && obj.size == 1 
    # raise DebugException, (obj.to_yaml rescue obj.inspect)
    insp = (obj.to_yaml rescue obj.inspect)
    raise insp
  end

  # I'm freak like this
  def exclusive_or(a, b)
    a && !b || !a && b
  end

  # puts only in development
  def dputs(*args)
    Rails.development? && puts(*args)
  end  
end