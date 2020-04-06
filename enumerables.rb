module Enumerable
  def my_each
    i = 0
    loop do
      yield self[i]
      i += 1
      break if i == size

      self
    end
  end

  def my_each_with_index
    i = 0
    index = 0
    loop do
      yield self[i], index
      i += 1
      index += 1
      break if i == size

      self
    end
  end

  def my_select
    selection = []
    my_each do |x|
      selection << x if (yield x) == true
    end
    selection
  end

  def my_all?
    my_each do |x|
      return false unless yield x
    end
    true
  end

  def my_any?
    my_each do |x|
      return true if yield x
    end
    false
  end

  def my_none?
    my_each do |x|
      return false if yield x
    end
    true
  end

  def my_count
    i = 0
    my_each do |x|
      i += 1 if yield x
    end
    i
  end

  def my_map
    mapped_arr = []
    my_each do |x|
      mapped_arr << if block_given?
                      yield(x)
                    else
                      proc.call(x)
                    end
      mapped_arr
    end
  end

  def my_inject(accumulator = nil)
    acc = case accumulator
          when Symbol
            return my_inject { |acc, x| acc.send(accumulator, x) }
          when nil
            nil
          else
            accumulator
          end
    my_each do |x|
      acc = if acc.nil?
              x
            else
              yield(acc, x)
            end
    end
    acc
  end
end

def multiply_els(array)
  array.my_inject(:+)
end
puts multiply_els([2,4,5])
# [5, 2, 3].my_all?
