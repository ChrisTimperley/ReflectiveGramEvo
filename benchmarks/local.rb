# encoding: utf-8

require_relative 'base'

run('Local',
  'local', {
  'Population' => 161,
  'Elites' => 0.459,
  'Tournament' => 4,
  'Mutation' => 0.363,
  'Crossover' => 0.544
})
