# encoding: utf-8
require 'matrix'

# Load the necessary operators.
require_relative 'operators'
require_relative 'evaluator'

Parameter = Struct.new(:name, :range)

# Tunes a given algorithm using REVAC.
#
# ==== Parameters
# [+opts+]  A hash of keyword options to this method.
#
# ==== Options
# [+parameters+]      A list of parameters to optimise. Each entry in the list
#                     contains the name of the parameter and the range of values
#                     that it can take.
# [+iteration_limit+] The maximum number of iterations to perform.
# [+num_parents+]     The number of parents to use when creating each child.
# [+runs+]            The number of runs to perform for each vector.
# [+vectors+]         The number of parameter vectors in the population.
def revac(opts = {})

  # The RNG to use during optimisation.
  random = Random.new

  # Convert the list of parameter name/range pairs into a list of parameter
  # objects.
  parameters = opts[:parameters].map { |n, r| Parameter.new(n, r) }

  # Draw an initial set of parameter vectors at uniform random from
  # their initial distributions.
  table = Matrix.build(opts[:vectors], parameters.length) do |v, p|
    random.rand(opts[:parameters][p].range)
  end

  # Compute the utility of each parameter vector.
  utility = calculate_utility(table)

  until iterations == opts[:iteration_limit]
    
    # Select the N-best vectors from the table as the parents
    # of the next parameter vector.
    parents = (0...opts[:vectors]).sort { |x, y|
      utility[x] <=> utility[y] }.take(opts[:parents])

    # Perform multi-parent crossover on the N parents to create
    # a proto-child vector.
    child = multi_parent_crossover(random, parents)

    # Compute the utility of the new parameter vector and insert
    # it into the "youngest" row of the table.
    utility[0] = evaluate_vector(vector, algorithm, opts[:runs])

  end

end
