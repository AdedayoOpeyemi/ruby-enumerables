
module Enumerable
  
  def my_each
    for x in self [0..-1]
      yield x
    end
  end

  def my_each_with_index
    i=0
    for x in self [0..-1]
      yield x, [i]
      i+=1
    end
  end

  def my_select
    selection = []
    self.my_each do |x|
      selection << x if yield x
    end
  end

  def my_all?
    self.my_each do |x|
      return false unless yield x
    end
    true
  end

  def my_any?
    self.my_each do |x|
      return true if yield x
    end 
    false 
  end

  def my_none?
    self.my_each do |x|
      return false if yield x
    end
    true
  end

end



puts ["lovess","hatess","yearss"].my_all? { |y| y.length == 6 }