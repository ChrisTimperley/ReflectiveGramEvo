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
# [+variables+] The variables of the compiled function.
# [+measure+]   The name of the robustness measure being used.
# [+max_wraps+] The maximum number of times the genome should be wrapped
#               during derivation.
#
# ==== Returns
# A callable lambda function of a type appropriate the robustness
# measures being used.
def compile(sequence, grammar, variables, measure, max_wraps = 1)
  derivation = grammar.derive(sequence, max_wraps: max_wraps)
  case measure
  when 'Global'
    return ToRobust::Global::GlobalRobustLambda(variables, derivation)
  when 'Local'
    return ToRobust::Local::LocalRobustLambda(variables, derivation, [FunC])
  else
    return derivation.to_lambda(variables)
  end
end

# Evaluates as many candidate individuals as possible until all
# candidates have been evaluated or the evaluation limit has been
# reached.
#
# ==== Parameters
# [+candidates+]        A list of candidates to evaluate.
# [+num_evaluations+]   The number of evaluations performed so far.
# [+opts+]              A hash of keyword options to this method.
#
# ==== Options
# [+evaluation_limit+]  The maximum number of evaluations.
# [+measure+]           The robustness measure being used.
# [+benchmark+]         The benchmark function being used.
#
# ==== Returns
# The number of evaluations that were performed.
def evaluate!(candidates, num_evaluations, opts = {})

  # If there are more candidate solutions than there are remaining
  # evaluations, then shuffle the list of candidates and evaluate
  # as many as possible.
	evals_remaining = opts[:evaluation_limit] - num_evaluations
	if evals_remaining > candidates
		candidates = candidates.shuffle.[0...evals_remaining]
	end



  # Return the number of evaluated candidates.
  return candidates.length

end