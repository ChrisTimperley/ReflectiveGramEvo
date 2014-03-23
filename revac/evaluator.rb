# encoding: utf-8

# Computes the utility (response) of a given parameter vector.
#
# ==== Parameters
# [+vector+]    The parameter vector to evaluate.
# [+algorithm+] A function which takes the a hash of parameter
#               values as input, performs a given algorithm and
#               returns the best fitness value found.
# [+runs+]      The number of runs to use for each parameter
#               vector.
def evaluate_vector(vector, algorithm, runs)

  # Transform the vector into a hash of parameter names and
  # settings and compute the mean best fitness using this
  # parameter vector across a given number of runs.
  vector = Hash[vector.to_a.each_with_index.map { |v, i|
    [parameters[i].name, v]
  }]
  Array.new(runs) { algorithm[vector] }.inject(:+).to_f / runs

end

