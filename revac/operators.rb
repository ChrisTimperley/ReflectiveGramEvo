# encoding: utf-8

# Performs a multi-parent crossover on a list of parent chromosomes to produce
# a new chromosome.
def multi_parent_crossover(random, parents)
  Array.new { parents[random.rand(parents.length)][i] }
end
