# encoding: utf-8

class Individual

  include Comparable

  attr_accessor :fitness
  attr_accessor :chromosome

  def initialize(chromosome)
    @chromosome = chromosome
    @fitness = nil
  end

  def <=>(other)
    return 1 if fitness.nil?
    return -1 if other.fitness.nil?
    return fitness <=> other.fitness
  end

end
