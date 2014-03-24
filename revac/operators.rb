# encoding: utf-8

# Performs a multi-parent crossover on a list of parent chromosomes to produce
# a new chromosome.
def multi_parent_crossover(random, parents)
  Array.new(parents[0].length) { |i| parents[random.rand(parents.length)][i] }
end

# Performs REVAC mutation on an individual at a given index within the vector
# table to produce a new mutated vector.
#
# ==== Parameters
# [+random+]  The random number generator.
# [+table+]   The vector table.
# [+index+]   The index of the individual to mutate.
# [+h+]       The radius of the partial marginal density function.
#
# ==== Returns
# The resulting vector.
def revac_mutate(random, table, index, h)

  # Sort the values of this parameter for all vectors into ascending order
  # before calculating the upper and lower bounds of the mutation distribution
  # and drawing a new parameter value at uniform random.
  return Array.new(table[0].length) do |i|
    window = (0...table.length).sort { |x, y| table[x][i] <=> table[y][i] }
    position = window.find_index(index)
    window = [
      window[[position - h, 0].max],
      window[[position + h, table.length - 1].min]
    ]
    window = table[window[0]][i] .. table[window[1]][i]
    random.rand(window)
  end
  
end