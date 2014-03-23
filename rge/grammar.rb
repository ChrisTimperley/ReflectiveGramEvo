# encoding: utf-8

# This class holds the details of a context free grammar (CFG) and provides
# methods for producing a derivation from a given sequence of integers.
#
# Rather than having a special class for grammar sequences, we simply use
# arrays to store grammar sequences, ensuring the best possible compatibility
# with existing array-based operators.
class Grammar

  # Used to represent literals in a CFG.
  Literal = Struct.new(:value)

  # Used to represent symbols in a CFG.
  Symbol = Struct.new(:value)

  # The GrammarDerivation class is used to hold a derivation of a grammar
  # produced by some provided sequence of integers. This class implements
  # methods for transforming the derivation into other forms.
  class GrammarDerivation < String

    # Produces a lambda function from a given grammar derivation and a set
    # of arguments.
    #
    # ==== Parameters
    # [+args+]        An ordered array of the arguments to the lambda function.
    # [+derivation+]  The grammar derivation to use as the body of the function.
    #
    # ==== Returns
    # The compiled lambda function.
    def self.to_lambda(args, derivation)
      eval("lambda { |#{args.join(',')}| #{derivation} }")
    end

    # Converts this derivation into a usable lambda function that accepts
    # a given set of arguments.
    #
    # ==== Parameters
    # [+args+]  An ordered array of the arguments to the lambda function.
    #
    # ==== Returns
    # The compiled lambda function.
    def to_lambda(args)
      GrammarDerivation.to_lambda(args, self)
    end

  end

  # The root symbol for this grammar (where all derivations begin).
  attr_reader :root

  # Constructs a new CFG.
  #
  # ==== Parameters
  # [+root+]  The root symbol in the grammar (at which all derivations start).
  # [+rules+] The rules of this grammar, given as a hash, indexed by symbol.
  def initialize(root, rules)

    # Convert each rule into a sequence of symbol derivations.
    # Transform each string-based derivation into a sequence of tokens.
    @rules = Hash[rules.map do |rule, derivations|
      derivations.map! do |derivation|
        tokens = []
        until derivation.empty?
          left, tag, right = derivation.partition(/{\w+}/)
          tokens << Literal.new(left) unless left.empty?
          tokens << Symbol.new(tag[1...-1]) unless tag.empty?
          derivation = right
        end
        tokens
      end
      [rule.to_s, derivations]
    end].freeze

    # TODO: Could ensure that the root is a valid symbol?
    @root = root.to_s.freeze
  end

  # Returns the number of symbols in the CFG.
  def size
    @rules.size
  end
  alias_method :length, :size

  # Returns the list of possible derivations for a given symbol.
  def [](symbol)
    @rules[symbol]
  end
  alias_method :derivations, :[]

  # Produces a grammar derivation from a given sequence of integers.
  #
  # ==== Parameters
  # * sequence, the sequence of integers to produce a derivation from.
  # * opts, a hash of keyword options for this method.
  #   -> random, the RNG to use during the derivation process.
  #   -> wrap, flag indicating whether the sequence should be wrapped when
  #      all genetic material has been used.
  #   -> max_wraps, the maximum number of times the sequence should be
  #      wrapped.
  #
  # *Returns:*
  # A grammar derivation object for the produced derivation.
  def derive(sequence, opts = {})
    opts[:wrap] = true # for now wrapping is forced.
    opts[:max_wraps] ||= 1 if opts[:wrap]

    derivation = GrammarDerivation.new

    # Keep processing the sequence of tokens until none remain.
    #
    # * Literal tokens are appended to the end of the derivation.
    # * Symbol tokens are converted into a given symbol derivation,
    #   using the next codon as the index if there is more than a single
    #   choice.
    # * When there are no codons left to consume then we either:
    #   a) Add a new codon to the sequence (until the limit is reached).
    #      [DISABLED]
    #   b) Reset the codon index to zero, wrapping the sequence round.
    queue = [Symbol.new(@root)]
    codon_index = 0
    sequence_length = sequence.length
    num_wraps = 0

    until queue.empty?
      token = queue.shift
      
      if token.is_a?(Literal)
        derivation << token.value
      else
        options = @rules[token.value]
        if options.length == 1
          queue = options[0] + queue
        else

          # Check if there are no remaining codons in the sequence.
          if codon_index >= sequence_length

            # If wrapping is enabled, reset the codon pointer to the
            # start of the sequence, unless the maximum number of wraps
            # has been encountered.
            if opts[:wrap]
              if num_wraps != opts[:max_wraps]
                fail(Errors::GenotypeExhaustedError)
              end
              codon_index = 0
              num_wraps += 1
            end

          end

          queue = options[sequence[codon_index] % options.length] + queue
          codon_index += 1
        end
      end
    end

    derivation.freeze

  end

end
