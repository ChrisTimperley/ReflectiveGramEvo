# encoding: utf-8
#
# Generates samples for each of the regression problems.
require 'json'

num_samples = 20
var_domain = -3.0 .. 3.0

problems = {}
problems['keijzer-13'] = lambda { |x, y| x**4 + x**3 + (y**2)/2 - y }
problems['keijzer-16'] = lambda { |x, y| x**3 / 5 + y**3 / 2 - y - x }

problems.each do |name, f|
  problems[name] = Array.new(num_samples) do
    inputs = Array.new(f.arity) { Random.rand(var_domain) }
    inputs << f[*inputs]
  end
end

File.open('problems.json', 'w') do |f|
  f.write(JSON.pretty_generate(problems))
end
