# encoding: utf-8
#
# This file contains the function definitions for the genetic operators used
# by this algorithm.

# Performs uniform mutation on a given chromosome (destructively).
def mutate!(random, rate, values, chromosome)
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

# Destructively performs replacement on the population.
def replace!(population, offspring, num_elites)
  population[0...num_elites] = (population.sort)[0...num_elites]
  population[num_elites..-1] = offspring.[0...population.size - num_elites]
end

# Spawns a new individual containing a integer sequence of a given
# length at uniform random.
def spawn(random, length, values)
  Individual.new(Array.new(length) { values.sample(random: random) })
end
