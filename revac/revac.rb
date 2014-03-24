# encoding: utf-8

require 'json'

# Load the necessary operators.
require_relative 'operators'
require_relative 'evaluator'

Parameter = Struct.new(:name, :range)

# Logs the parameter vector table and utility function values for the current
# generation and adds them to both the output file and the output buffer.
#
# ==== Parameters
# [+path+]      The path to the output JSON file.
# [+iteration+] The current iteration.
# [+table+]     The parameter vector table.
# [+utility+]   The utility vector.
# [+buffer+]    The output buffer.
#
# ==== Returns
# An updated output buffer.
def revac_log(path, iteration, table, utility, buffer)
  File.open(path, 'w') do |file|
    buffer[:iterations][iteration] = {
      iteration: iteration,
      utility: utility.clone,
      table: table.map { |v| v.clone }
    }
    file.write(JSON.generate(buffer))
  end
  return buffer
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

  # Draw an initial set of parameter vectors at uniform random from
  # their initial distributions.
  table = Array.new(opts[:vectors]) do
    parameters.map { |p| random.rand(p.range) }
  end

  # Compute the utility of each parameter vector.
  utility = table.map do |v|
    evaluate_vector(v, parameters, algorithm, opts[:runs])
    puts "evaluated"
  end

  # Initialise evolution statistics.
  oldest = 0
  iterations = 0
  evaluations = opts[:vectors]

  # Log the details of the initial population.
  output_buffer = revac_log(opts[:output],
    iterations,
    table,
    utility,
    {iterations: []})

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
    utility[child_index] = evaluate_vector(child, parameters, algorithm, opts[:runs])

    # Update evolution statistics.
    oldest = (oldest + 1) % opts[:vectors]
    iterations += 1
    evaluations += 1

    # Log the vector table and the utility function values.
    output_buffer = revac_log(opts[:output],
      iterations,
      table,
      utility,
      output_buffer)

    # Debugging.
    puts "Generation #{iterations}: utility.min"

  end



end
