require "big"
require "phelix/builtins"

class Phelix
  enum Type
    Num; Str; Fun; Word
  end
  alias Value = BigInt | String | Bool | Phelix | Array(Value)

  record Insn, t : Type, v : Value

  @@env = {} of String => Phelix
  @tokens = [] of String
  @insns = [] of Insn
  @stack = [] of Value

  getter stack

  def initialize(@tokens)
    parse
  end

  def parse
    ts = @tokens.dup
    find = ->(needle : String) {
      fn = [] of String
      while t = ts.shift?
        break if t == needle
        fn << t
      end
      Phelix.new fn
    }

    while tok = ts.shift?
      next @@env[tok[0..-2]] = find.call(";") if tok[-1] == ':'

      @insns << Insn.new *case
      when n = tok.to_i? then {Type::Num, n.to_big_i}
      when tok[0] == '"' then {Type::Str, tok[1..-2]}
      when tok == "("    then {Type::Fun, find.call ")"}
      else                    {Type::Word, tok}
      end
    end
  end

  def evaluate(stack = [] of Value)
    @insns.each do |insn|
      case insn.t
      when Type::Num, Type::Str, Type::Fun
        stack << insn.v
      when Type::Word
        word = insn.v.as(String)
        if fn = @@env[word]? # let user-defined words take precedence
          fn.evaluate stack
        elsif word[0] == '\''
          stack << @@env[word[1..-1]]
        elsif op = @@builtins[word]?
          op.call stack
        else
          abort "unknown word '#{word}'"
        end
      end
    end

    @stack = stack
  end

  def self.tokenize(src)
    src
      .gsub(/#.*/, "")                                      # strip comments
      .gsub(/[)(]/, " \\0 ")                                # pad parens for easy tokenization
      .gsub(/\[([^\]]+)\]/) { "#{$1} #{$1.split.size} []" } # arrays
      .split
  end
end
