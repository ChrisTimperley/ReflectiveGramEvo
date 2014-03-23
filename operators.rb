# encoding: utf-8
#
# This file contains the function definitions for the genetic operators used
# by this algorithm.

# Performs uniform mutation on a given chromosome (destructively).
def mutation!(random, rate, values, chromosome)
  chromosome.each_index do |i|
    chromosome[i] = values.sample(random: random) if random.rand <= rate
  end
  return chromosome
end

# Destructively performs two-point crossover on two given chromosomes.
def crossover!(random, rate, c1, c2)
  
end

# Performs tournament selection.
def tournament_selection(random, candidates, size)
  candidates.sample(size, random: random).min
end
