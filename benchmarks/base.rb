# encoding: utf-8
require 'CSV'
require 'FileUtils'
require_relative '../rge/algorithm'

# Runs the appropriate algorithm using a given robustness measure for a given benchmark
# function.
def run(measure, output_dir, setup)

  benchmarks = [
    'keijzer-13',
    'keijzer-16'
  #  'keijzer-12',
  #  'keijzer-14',
  #  'keijzer-15'
  ]

  # Ensure that the output directory exists.
  FileUtils.mkdir(output_dir) unless File.exists?(output_dir)

  # Record the fitness values over 100 runs for each of the benchmark functions, logging
  # the results to a CSV file each time.
  benchmarks.each do |benchmark|

    repeats = 100
    fitnesses = Array.new(repeats) do |i|
      fitness = evolve(
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
      puts "#{benchmark}[#{i}]: #{fitness}"
      fitness
    end

    # Write the fitness values to a CSV log.
    CSV.open("#{output_dir}/#{benchmark}.csv", 'wb') do |csv|
      csv << ['Benchmark', 'Measure', 'Fitness']
      fitnesses.each do |f|
        csv << [benchmark, measure, f]
      end
    end

  end

end

