# encoding: utf-8
require_relative '../revac/revac'
require_relative '../rge/algorithm'

# Tunes a robustness measure using a competition-configured REVAC tuner on
# a given benchmark function.
def tune(measure, benchmark = 'keijzer-15')
  revac([
      ['Population', 10..200],
      ['Mutation', 0.0001..0.5],
      ['Crossover', 0.1..1.0],
      ['Tournament', 2..10],
      ['Elites', 0.0..0.5]
    ],
    output: 'testing.csv',
  ) do |setup|
    evolve(
      silent: true,
      population_size: setup['Population'],
      length: 100,
      evaluation_threads: 8,
      breeding_threads: 8,
      evaluation_limit: 10_000,
      elites: (setup['Population'] * setup['Elites']).floor,
      tournament_size: setup['Tournament'],
      mutation_rate: setup['Mutation'],
      crossover_rate: setup['Crossover'],
      measure: measure,
      benchmark: benchmark).fitness
  end
end
