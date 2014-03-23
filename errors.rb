# encoding: utf-8

module Errors

  # Thrown when all genetic material has been used when decoding a chromosome.
  class GenotypeExhaustedError < StandardError; end

end
