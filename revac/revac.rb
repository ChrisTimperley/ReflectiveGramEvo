# encoding: utf-8

# Load the necessary operators.
require_relative 'operators'
require_relative 'evaluator'

Parameter = Struct.new(:name, :range)

# Tunes a given algorithm using REVAC.
#
# ==== Parameters
# [+opts+]        A hash of keyword options to this method.
# [+&algorithm+]  A lambda function which takes a hash of named parameters
#                 as its input, uses them to perform a given algorithm,
#                 and returns the fitness of the best individual found.
#
# ==== Options
# [+parameters+]        A list of parameters to optimise. Each entry in the
#                       list contains the name of the parameter and the range
#                       of values that it can take.
# [+evaluations+]       The maximum number of evaluations to perform.
# [+parents+]           The number of parents to use when creating each child.
# [+runs+]              The number of runs to perform for each vector.
# [+vectors+]           The number of parameter vectors in the population.
# [+h+]                 The radius of the partial marginal density function.
def revac(opts = {}, &algorithm)

  # The RNG to use during optimisation.
  random = Random.new

  # Convert the list of parameter name/range pairs into a list of parameter
  # objects.
  parameters = opts[:parameters].map { |n, r| Parameter.new(n, r) }

  # Draw an initial set of parameter vectors at uniform random from
  # their initial distributions.
  table = Array.new(opts[:vectors]) do
    parameters.map { |p| random.rand(p.range) }
  end

  # Compute the utility of each parameter vector.
  utility = table.map { |v| evaluate_vector(v, &algorithm, opts[:runs]) }

  # Initialise evolution statistics.
  oldest = 0
  iterations = 0
  evaluations = opts[:vectors]

  # Keep optimising until the termination condition is met.
  until evaluations == opts[:evaluations]
    
    # Select the N-best vectors from the table as the parents
    # of the next parameter vector.
    parents = (0...opts[:vectors]).sort { |x, y|
      utility[x] <=> utility[y] }.take(opts[:parents])

    # Perform multi-parent crossover on the N parents to create
    # a proto-child vector.
    child = multi_parent_crossover(random, parents)

    # Replace the oldest vector from the population with this
    # proto-child vector, before mutating it and computing its
    # utility.
    table[oldest] = child
    table[oldest] = revac_mutate(random, table, oldest, opts[:h])
    utility[child_index] = evaluate_vector(child, &algorithm, opts[:runs])

    # Update evolution statistics.
    oldest = (oldest + 1) % opts[:vectors]
    iterations += 1
    evaluations += 1

    # Log the vector table and the utility function values.
    #
    #
    #
    #
    #
    #
    #

  end



end
