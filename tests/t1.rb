# encoding: utf-8

require_relative '../algorithm'

# [+population_size+]     The size of the population.
# [+length+]              The length of integer sequences.
# [+evaluation_threads+]  The number of threads used during evaluation.
# [+breeding_threads+]    The number of threads using during breeding.
# [+evalation_limit+]     The maximum number of evaluations.
# [+elites+]              The number of elite individuals.
# [+tournament_size+]     The size of tournaments.
# [+mutation_rate+]       The mutation rate.
# [+crossover_rate+]      The crossove rate.
# [+measure+]             The name of the robustness measure to use.
# [+benchmark+]           The name of the benchmark function to use.
evolve(
  population_size: 200,
  length: 100,
  evaluation_threads: 8,
  breeding_threads: 8,
  evaluation_limit: 20_000,
  elites: 1,
  tournament_size: 2,
  mutation_rate: 0.01,
  crossover_rate: 0.9,
  measure: 'Global',
  benchmark: 'keijzer-15')
