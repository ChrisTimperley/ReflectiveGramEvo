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
    return 1 if fitness.nil? || fitness.infinite? || fitness.nan?
    return -1 if other.fitness.nil? || other.fitness.infinite? || other.fitness.nan?
    return fitness <=> other.fitness
  end

end
