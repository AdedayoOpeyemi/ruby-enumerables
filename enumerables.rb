module Enumerable
  def my_each
    if block_given?
      i = 0
      loop do
        yield self[i]
        i += 1
        break if i == size

        self
      end
    else
      to_enum
    end
  end

  def my_each_with_index
    if block_given?
      i = 0
      index = 0
      loop do
        yield self[i], index
        i += 1
        index += 1
        break if i == size

        self
      end
    else
      to_enum
    end
  end

  def my_select
    if block_given?
      selection = []
      my_each do |x|
        selection << x if yield(x) == true
      end
      selection
    else
      to_enum
    end
  end

  def my_all?(args = nil)
    result = true
    if block_given? && args.nil?
      my_each do |x|
        result = false unless yield x
      end
    elsif !block_given? && args.nil?
      my_each do |x|
        result = false if x.nil? || false
      end
    elsif args.is_a? Class
      my_each do |x|
        result = false unless x.is_a? args
      end
    elsif args.is_a? Regexp
      my_each do |x|
        result = false unless x.match? args
      end
    else
      my_each do |x|
        result = false unless x == args
      end
    end
    result
  end

  def my_any?(args = nil)
    result = false
    if block_given? && args.nil?
      my_each do |x|
        result = true if yield x
      end
    elsif !block_given? && args.nil?
      my_each do |x|
        result = true unless x.nil? || false
      end
    elsif args.is_a? Class
      my_each do |x|
        result = true if x.is_a? args
      end
    elsif args.is_a? Regexp
      my_each do |x|
        result = true if x.match? args
      end
    else
      my_each do |x|
        result = true if x == args
      end
    end
    result
  end

  def my_none?(args = nil)
    result = true
    if block_given? && args.nil?
      my_each do |x|
        result = false if yield x
      end
    elsif !block_given? && args.nil? || false
      my_each do |x|
        result = false if x == true
      end
    elsif args.is_a? Class
      my_each do |x|
        result = false if x.is_a? args
      end
    elsif args.is_a? Regexp
      my_each do |x|
        result = false if x.match? args
      end
    else
      my_each do |x|
        result = false if x == args
      end
    end
    result
  end

  def my_count(args = nil)
    i = 0
    if block_given?
      my_each do |x|
        i += 1 if yield x
      end
    elsif !args.nil?
      my_each do |x|
        i += 1 if args == x
      end

    else
      i = size
    end
    i
  end

  def my_map(proc = nil)
    return to_enum unless block_given? || !proc.nil?

    result = []
    proc ?
    my_each do |x|
      result << proc.call(x)
    end :
    my_each do |x|
      result << yield(x)
    end
    result
  end

  def my_inject(accumulator = nil)
    acc = case accumulator
          when Symbol
            return my_inject { |a, b| a.send(accumulator, b) }
          when nil
            nil
          else
            accumulator
          end
    my_each do |x|
      acc =
        if acc.nil?
          x
        else
          yield(acc, x)
        end
    end
    acc
  end
end
