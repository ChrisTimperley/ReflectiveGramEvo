# encoding: utf-8
#
# This file contains functions responsible for evaluating potential
# solutions within the population.

# Compiles a given integer sequence into a Ruby lambda function of
# the appropriate type.
#
# ==== Parameters
# [+sequence+]  The integer sequence to compile.
# [+grammar+]   The grammar to use to create the derivation.
#
# ==== Options
# [+variables+] The variables of the compiled function.
# [+measure+]   The name of the robustness measure being used.
# [+max_wraps+] The maximum number of times the genome should be wrapped
#               during derivation.
#
# ==== Returns
# A callable lambda function of a type appropriate the robustness
# measures being used.
def compile(sequence, grammar, opts = {})
  derivation = grammar.derive(sequence, max_wraps: opts[:max_wraps])
  case opts[:measure]
  when 'Global'
    return ToRobust::Global::GlobalRobustLambda.new(opts[:variables], derivation)
  when 'Local'
    return ToRobust::Local::LocalRobustLambda.new(opts[:variables], derivation, [FunC])
  else
    return derivation.to_lambda(opts[:variables])
  end
end

# Evaluates as many candidate individuals as possible until all
# candidates have been evaluated or the evaluation limit has been
# reached.
#
# ==== Parameters
# [+candidates+]        A list of candidates to evaluate.
# [+opts+]              A hash of keyword options to this method.
#
# ==== Options
# [+num_evaluations+]     The number of evaluations performed so far.
# [+evaluation_limit+]    The maximum number of evaluations.
# [+measure+]             The robustness measure being used.
# [+benchmark+]           The benchmark function being used.
# [+evaluation_threads+]  The number of threads available for evaluation.
# [+grammar+]             The grammar being used by the evolution.
# [+max_wraps+]           The maximum number of times the genome should
#                         be wrapped during derivation.
# [+samples+]             The set of samples from each benchmark function
#                         to use for regression.
#
# ==== Returns
# The number of evaluations that were performed.
def evaluate!(candidates, opts = {})

  # If there are more candidate solutions than there are remaining
  # evaluations, then shuffle the list of candidates and evaluate
  # as many as possible.
	evals_remaining = opts[:evaluation_limit] - opts[:num_evaluations]
	if evals_remaining > candidates.length
		candidates = candidates.shuffle[0...evals_remaining]
	end

  # Extract the samples and variable set for the benchmark.
  samples = opts[:samples][opts[:benchmark]]
  variables = samples[0].length == 3 ? ['x', 'y'] : ['x']

  # Split the list of candidates across each of the available threads.
  # If there is an error during the evaluation of a candidate then
  # set the fitness of that candidate to infinity (the worst possible).
  candidates.peach(opts[:evaluation_threads]) do |c|
    begin
      lm = compile(c.chromosome,
        opts[:grammar],
        variables: variables,
        measure: opts[:measure])
      c.fitness = samples.reduce(0) do |sum, sample|
        sum += (lm[*sample[0...-1]] - sample[-1])**2
      end
    rescue StandardError => e
      c.fitness = Float::INFINITY
    end
  end

  # Return the number of evaluated candidates.
  return candidates.length

end
