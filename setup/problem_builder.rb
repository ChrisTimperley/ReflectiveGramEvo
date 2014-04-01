# encoding: utf-8
#
# Generates samples for each of the regression problems.
require 'json'

num_samples = 20
var_domain = -1.0 .. 1.0

problems = {}
problems['koza-1'] = lambda { |x| x**4 + x**3 + x**2 + x }
problems['koza-3'] = lambda { |x| x**6 - (2*x**4) + x**2 }

problems.each do |name, f|
  problems[name] = Array.new(num_samples) do
    inputs = Array.new(f.arity) { Random.rand(var_domain) }
    inputs << f[*inputs]
  end
end

File.open('problems.json', 'w') do |f|
  f.write(JSON.pretty_generate(problems))
end
