# encoding: utf-8
require_relative 'operators'
require_relative 'evaluator'

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
def evolve(parameters = {})

  values = 0..2_147_483_647
  num_offspring = opts[:population_size] - opts[:elites]

  # Calculate division of labour for breeding.
  batch_size = (num_offspring / opts[:breeding_threads].to_f).ceil
  batches = Array.new(threads) do |t|
    start_at = t * batch_size
    end_at = [num_offspring, start_at + batch_size].min
    [t, start_at, end_at]
  end

  # Setup the RNGs.
  threads =[opts[:breeding_threads], opts[:evaluation_threads]].max
  random = Array.new(threads) { Random.new }

  # Initialise the population.
  population = Array.new(opts[:population_size]) do
    spawn(random[0], opts[:length], values)
  end

  # Evaluate the population and find the best solution.
  num_evaluations = evaluate!(population,
    num_evaluations: 0,
    evaluation_limit: opts[:evaluation_limit])
  best_individual = population.min
  generations = 0

  # Keep evolving until the evaluation limit is reached.
  until num_evaluations >= opts[:evaluation_limit]

    # Keep generating individuals until we run out of space.
    offspring = Array.new(num_offspring, nil)
    batches.peach do |t, start_at, end_at|
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
      num_evaluations: num_evaluations,
      evaluation_limit: opts[:evaluation_limit])
    best_offspring = offspring.min
    best_individual = best_offspring if best_offspring < best_individual

    # Perform replacement to give the population for the next generation.  
    replace!(population, offspring, opts[:elites])
    generations += 1

    # DEBUGGING
    puts "Generation #{generations}: #{best_individual.fitness}"

  end


end
