# frozen_string_literal:true

module Enumerable
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(self[i], i)
      i += 1
    end
  end

  def my_select
    my_each { |num| puts num if yield(num) }
  end

  def my_all?
    my_each { |num| return false unless yield(num) }
    true
  end

  def my_any?
    my_each { |num| return true unless yield(num) }
    false
  end

  def my_none?
    my_each { |num| return false if yield(num) }
    true
  end

  def my_count
    count = 0
    my_each do |num|
      count += 1 if yield(num)
    end
    count
  end

  def my_map
    my_each { |num| puts yield(num) }
  end

  def my_inject
    result = self[0]
    my_each_with_index do |num, i|
      result = yield(result, num) unless i.zero?
    end
    result
  end
end

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

# my_any? method
puts(arr.my_any? { |a| (a % 3).zero? })
puts(arr.any? { |a| (a % 3).zero? })

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
puts(arr.my_inject { |sum, a| sum * a })
puts(arr.inject { |sum, a| sum * a })
