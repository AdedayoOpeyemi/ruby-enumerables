module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      if is_a? Array
        yield self[i]
        i += 1
        self
      elsif is_a? Range
        yield to_a[i]
        i += 1
        self
      else
        to_enum
      end
    end
  end

  def my_each_with_index
    if block_given?
      i = 0
      index = 0
      while i < size
        yield self[i], index
        i += 1
        index += 1

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
        result = false if x.nil? || x == false
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
        result = true unless x.nil? || x == false
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
    elsif !block_given? && args.nil? || x == false
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

  def my_inject(accumulator = nil, operation = nil, &block)
    if operation.nil? && block.nil?
      operation = accumulator
      accumulator = nil
    end

    block = case operation
            when Symbol
              ->(acc, value) { acc.send(operation, value) }
            when nil
              block
            end

    if accumulator.nil?
      no_acc = true
      accumulator = first
    end

    index = 0

    my_each do |element|
      accumulator = block.call(accumulator, element) unless no_acc && index.zero?
      index += 1
    end
    accumulator
  end
end
