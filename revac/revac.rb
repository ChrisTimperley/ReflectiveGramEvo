# encoding: utf-8
require 'CSV'

# Load the necessary operators.
require_relative 'operators'
require_relative 'evaluator'

Parameter = Struct.new(:name, :range)

# Logs a parameter vector and its associated utility function value using
# a given CSV file.
#
# ==== Parameters
# [+path+]        The path to the output JSON file.
# [+evaluation+]  The current evaluation.
# [+vector+]      The parameter vector table.
# [+utility+]     The utility of the given vector.
def revac_log(path, evaluation, vector, utility)
  CSV.open(path, 'ab') do |f|
    f << [evaluation] + vector + [utility]
  end
end

# Tunes a given algorithm using REVAC.
#
# ==== Parameters
# [+parameters+]        A list of parameters to optimise. Each entry in the
#                       list contains the name of the parameter and the range
#                       of values that it can take.
# [+opts+]        A hash of keyword options to this method.
# [+&algorithm+]  A lambda function which takes a hash of named parameters
#                 as its input, uses them to perform a given algorithm,
#                 and returns the fitness of the best individual found.
#
# ==== Options
# [+evaluations+]       The maximum number of evaluations to perform.
# [+parents+]           The number of parents to use when creating each child.
# [+runs+]              The number of runs to perform for each vector.
# [+vectors+]           The number of parameter vectors in the population.
# [+h+]                 The radius of the partial marginal density function.
# [+output+]            The path to the output JSON file.
def revac(parameters, opts = {}, &algorithm)

  # Load the default values for any omitted parameters.
  opts[:vectors] ||= 80
  opts[:parents] ||= 40
  opts[:h] ||= 10
  opts[:runs] ||= 5
  opts[:evaluations] ||= 5000

  # The RNG to use during optimisation.
  random = Random.new

  # Convert the list of parameter name/range pairs into a list of parameter
  # objects.
  parameters = parameters.map { |n, r| Parameter.new(n, r) }

  # Initialise evolution statistics.
  oldest = 0
  iterations = 0
  evaluations = 0

  # Initialise the output CSV file.
  CSV.open(opts[:output], 'wb') do |f|
    f << ['Evaluation'] + parameters.map { |p| p.name } + ['Utility']
  end

  # Draw an initial set of parameter vectors at uniform random from
  # their initial distributions.
  table = Array.new(opts[:vectors]) do
    parameters.map { |p| random.rand(p.range) }
  end

  # Compute the utility of each parameter vector, before finding and recording
  # the best parameter vector.
  utility = table.map do |v|
    u = evaluate_vector(v, parameters, algorithm, opts[:runs])
    revac_log(opts[:output], evaluations, v, u)
    evaluations += 1
    u
  end
  best_utility, best_vector = utility.each_with_index.min
  best_vector = table[best_vector]

  # Keep optimising until the termination condition is met.
  until evaluations == opts[:evaluations]
    
    # Select the N-best vectors from the table as the parents
    # of the next parameter vector.
    parents = (0...opts[:vectors]).sort { |x, y|
      utility[x] <=> utility[y]
    }.take(opts[:parents]).map { |i| 
      table[i]
    }

    # Perform multi-parent crossover on the N parents to create
    # a proto-child vector.
    child = multi_parent_crossover(random, parents)

    # Replace the oldest vector from the population with this
    # proto-child vector, before mutating it and computing its
    # utility.
    table[oldest] = child
    table[oldest] = revac_mutate(random, table, oldest, opts[:h])
    utility[oldest] = evaluate_vector(child, parameters, algorithm, opts[:runs])

    # Update the best vector if the child vector is an improvement.
    if utility[oldest] < best_utility
      best_vector = table[oldest]
      best_utility = utility[oldest]
    end

    # Update evolution statistics and perform logging.
    iterations += 1
    evaluations += 1
    revac_log(opts[:output], evaluations, child, utility[oldest])
    oldest = (oldest + 1) % opts[:vectors]

    # Debugging.
    puts "Generation #{iterations}: #{best_utility}"

  end



end
