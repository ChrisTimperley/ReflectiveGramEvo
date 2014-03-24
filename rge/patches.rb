# encoding: utf-8
#
# Takes +#in_groups+ method from Rails.
class Array
 
  # File activesupport/lib/active_support/core_ext/array/grouping.rb, line 57
  def in_groups(number)

    # size / number gives minor group size;
    # size % number gives how many objects need extra accommodation;
    # each group hold either division or division + 1 items.
    division = size.div number
    modulo = size % number

    # create a new array avoiding dup
    groups = []
    start = 0

    number.times do |index|
      length = division + (modulo > 0 && modulo > index ? 1 : 0)
      groups << last_group = slice(start, length)
      start += length
    end

    return groups

  end

end
