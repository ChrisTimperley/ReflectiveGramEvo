# encoding: utf-8
require 'json'
require 'peach'

# FOR NOW
require_relative '../../ruby_to_robust/lib/to_robust'

require_relative 'patches'
require_relative 'errors'
require_relative 'operators'
require_relative 'evaluator'
require_relative 'grammar'
require_relative 'individual'

require_relative 'functions'

# Enable all the core error handling strategies.
ToRobust::Global.strategies << ToRobust::Global::Strategies::DivideByZeroStrategy.new
ToRobust::Global.strategies << ToRobust::Global::Strategies::NoMethodErrorStrategy.new(5)
ToRobust::Global.strategies << ToRobust::Global::Strategies::WrongArgumentsErrorStrategy.new

# ==== Options
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
# [+silent+]              If this flag is set to true, no console output is produced.
def evolve(opts = {})

  values = 0..2_147_483_647
  num_offspring = opts[:population_size] - opts[:elites]

  # Ensure that only a single thread is used for evaluation if local
  # robustness is being used.
  opts[:evaluation_theads] = 1 if opts[:measure] == 'Local'

  # Load the benchmark function samples.
  samples = JSON.load(File.open("#{File.dirname(__FILE__)}/samples.json", 'rb')).freeze

  # Determine the number of arguments to the target function.
  vars = samples[opts[:benchmark]][0].length == 3 ? ['x', 'y'] : ['x']

  # Calculate division of labour for breeding.
  batches = (0...num_offspring).to_a.in_groups(opts[:breeding_threads])
  batches = Array.new(opts[:breeding_threads]) do |t|
    [t, batches[t][0], batches[t][-1] + 1]
  end

  # Construct the soft grammar.
  grammar = JSON.load(File.open("#{File.dirname(__FILE__)}/grammar.json", 'rb'))
  grammar['var'] = vars
  grammar = Grammar.new('program', grammar)

  # Setup the RNGs.
  threads = [opts[:breeding_threads], opts[:evaluation_threads]].max
  random = Array.new(threads) { Random.new }

  # Initialise the population.
  population = Array.new(opts[:population_size]) do
    spawn(random[0], opts[:length], values)
  end

  # Evaluate the population and find the best solution.
  num_evaluations = evaluate!(population,
    benchmark: opts[:benchmark],
    measure: opts[:measure],
    samples: samples,
    grammar: grammar,
    evaluation_threads: opts[:evaluation_threads],
    num_evaluations: 0,
    evaluation_limit: opts[:evaluation_limit])

  best_individual = population.min
  generations = 0

  # Keep evolving until the evaluation limit is reached.
  until num_evaluations >= opts[:evaluation_limit]

    # Keep generating individuals until we run out of space.
    offspring = Array.new(num_offspring, nil)
    batches.peach(opts[:breeding_threads]) do |t, start_at, end_at|

      until start_at == end_at
        
        # Select and clone two parents from the existing population.
        x = tournament_selection(random[t],
              population,
              opts[:tournament_size]).clone
        y = tournament_selection(random[t],
              population,
              opts[:tournament_size]).clone

        # Perform two point crossover on the two parents to produce
        # two proto-children.
        crossover!(random[t],
          opts[:crossover_rate],
          x.chromosome,
          y.chromosome)

        # Perform mutation on the two proto-children to produce two
        # complete offspring for the next generation.
        mutate!(random[t],
          opts[:mutation_rate],
          values,
          x.chromosome)
        offspring[start_at] = x
        start_at += 1

        # Only mutate and add the second proto-child to the offspring
        # if there is room for it.
        unless start_at == end_at
          mutate!(random[t],
            opts[:mutation_rate],
            values,
            y.chromosome)
          offspring[start_at] = y
          start_at += 1
        end

      end
    end

    # Evaluate the newly created offspring and compare the best individual
    # against the best found so far during the evolution.
    num_evaluations += evaluate!(offspring,
      benchmark: opts[:benchmark],
      measure: opts[:measure],
      samples: samples,
      grammar: grammar,
      num_evaluations: num_evaluations,
      evaluation_limit: opts[:evaluation_limit])

    best_offspring = offspring.min
    best_individual = best_offspring if best_offspring < best_individual

    # Perform replacement to give the population for the next generation.  
    replace!(population, offspring, opts[:elites])
    generations += 1

    # Console output.
    unless opts[:silent]
      puts "Generation #{generations}: #{best_individual.fitness}"
    end

  end

  # Return the best individual found during the evolution.
  return best_individual

end
