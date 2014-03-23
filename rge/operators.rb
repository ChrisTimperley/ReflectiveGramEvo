# encoding: utf-8
#
# This file contains the function definitions for the genetic operators used
# by this algorithm.

# Performs uniform mutation on a given chromosome (destructively).
def mutate!(random, rate, values, chromosome)
  chromosome.each_index do |i|
    chromosome[i] = random.rand(values) if random.rand <= rate
  end
end

# Destructively performs two-point crossover on two given chromosomes.
def crossover!(random, rate, c1, c2)
  
  # Perform crossover operation on a set proportion of requests.
  return unless rate <= random.rand

  # Calculate crossover points X and Y, then swap the substrings between
  # the two input chromosomes at those loci.
  x = random.rand(1...([c1.length, c2.length].min - 1))
  y = random.rand(x...([c1.length, c2.length].min))

  # Use a temporary buffer to perform the swap.
  t = c1[x...y]
  c1[x...y] = c2[x...y]
  c2[x...y] = t

end

# Performs tournament selection.
def tournament_selection(random, candidates, size)
  candidates.sample(size, random: random).min
end

# Destructively performs replacement on the population.
def replace!(population, offspring, num_elites)
  population[0...num_elites] = (population.sort)[0...num_elites]
  population[num_elites..-1] = offspring[0...(population.size - num_elites)]
end

# Spawns a new individual containing a integer sequence of a given
# length at uniform random.
def spawn(random, length, values)
  Individual.new(Array.new(length) { random.rand(values) })
end
