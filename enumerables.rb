
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

  def my_count
    i = 0
    self.my_each do |x|
      if yield (x) == true
        i += 1
      end
    end
    i
  end

  def my_map 
    mapped_arr = []
    self.my_each do |x|
      mapped_arr << yield(x)
    end
    mapped_arr
  end

  def my_inject 
    self.my_each do |x|
 
end



 puts [4,4,4,4,4].my_map { |y| y *2}