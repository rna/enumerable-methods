# frozen_string_literal:true

module Enumerable
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def my_each
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |element| result.push(element) if yield(element) }
    result
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |element| return false unless yield(element) }
    elsif arg.is_a? Regexp
      my_each { |element| return false unless arg =~ element }
    elsif arg.is_a? Class
      my_each { |element| return false unless element.class == arg }
    else
      my_each { |element| return false unless element }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |element| return true if yield(element) }
    elsif arg.is_a? Regexp
      my_each { |element| return true if arg =~ element }
    elsif arg.is_a? Class
      my_each { |element| return true if element.class == arg }
    else
      my_each { |element| return true if element }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |element| return false if yield(element) }
    elsif arg.is_a? Regexp
      my_each { |element| return false if arg =~ element }
    elsif arg.is_a? Class
      my_each { |element| return false if element.class == arg }
    else
      my_each { |element| return false if element }
    end
    true
  end

  def my_count
    count = 0
    my_each do |element|
      count += 1 if yield(element)
    end
    count
  end

  def my_map(my_proc = nil)
    return to_enum(:my_map) unless block_given? || my_proc

    result = []
    if my_proc.nil?
      my_each { |element| result << yield(element) }
    else
      my_each { |element| result << (my_proc.call element) }
    end
    result
  end

  def my_inject(init = nil, arg = nil)
    result = self[0]
    if block_given?
      my_each_with_index do |element, i|
        result = yield(result, element) unless i.zero?
      end
    else
      my_each_with_index do |element, i|
        sym = init.is_a?(Symbol) ? init : arg
        result = result.send(sym, element) unless i.zero?
      end
    end
    result
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
end

# method to test the my_inject method
def multiply_els(arr)
  arr.my_inject { |result, element| result * element }
end

# Testing each method against original with puts

arr = [1, 2, 3, 4, 5, 6]

# my_each method
arr.my_each { |a| puts a }
arr.each { |a| puts a }

# my_each_with_index method
arr.my_each_with_index { |a, i| puts "Value at index #{i} : #{a}" }
arr.each_with_index { |a, i| puts "Value at index #{i} : #{a}" }

# my_select method
puts(arr.my_select { |a| a > 3 })
puts(arr.select { |a| a > 3 })

# my_all? method
puts(arr.my_all? { |a| (a % 3).zero? })
puts(arr.all? { |a| (a % 3).zero? })
puts([nil, true, 99].my_all?)
puts([nil, true, 99].all?)
puts(arr.my_all?(String))

# my_any? method
puts(arr.my_any? { |a| (a % 3).zero? })
puts(arr.any? { |a| (a % 3).zero? })
puts([nil, nil, nil].my_any?)
puts([nil, nil, nil].any?)
puts(arr.my_any?(Integer))

# my_none? method
puts(arr.my_none? { |a| (a % 3).zero? })
puts(arr.none? { |a| (a % 3).zero? })

# my_count method
puts(arr.my_count { |a| (a % 2).zero? })
puts(arr.count { |a| (a % 2).zero? })

# my_map method
puts(arr.my_map { |a| a * 2 })
puts(arr.map { |a| a * 2 })

# my_inject method
puts(arr.my_inject { |sum, a| sum + a })
puts(arr.inject { |sum, a| sum + a })
puts(arr.my_inject(:+))

# Testing my_inject method with multiply_els method
puts multiply_els([2, 4, 5])

# Testing my_map method with passing Proc & Block at the same time
puts arr.my_map(proc { |a| a * 3 }) { |a| a * 2 }
