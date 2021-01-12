require "big"
require "phelix/builtins"

class Phelix
  alias Num = BigInt
  alias Str = String
  alias Val = Bool | Fun | Num | Str | Vec
  alias Vec = Array(Val)
  alias Fun = self | (Vec -> Vec)

  enum Type; Num; Str; Fun; Word end

  record Insn, t : Type, v : Val

  @@env = {} of Str => Fun
  @tokens = [] of String
  @insns = [] of Insn

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

  def call(stack = Vec.new)
    @insns.each do |insn|
      case insn.t
      when Type::Num, Type::Str, Type::Fun
        stack << insn.v
      when Type::Word
        word = insn.v.as String
        if fn = @@env[word]? # let user-defined words take precedence
          fn.call stack
        elsif word[0] == '\''
          stack << @@env[word[1..-1]]
        else
          abort "unknown word '#{word}'"
        end
      end
    end

    stack
  end

  def inspect(io)
    io << "(#{@tokens.join ' '})"
  end

  def self.tokenize(src)
    src
      .gsub(/#.*/, "")                                      # strip comments
      .gsub(/[)(]/, " \\0 ")                                # pad parens for easy tokenization
      .gsub(/\[([^\]]+)\]/) { "#{$1} #{$1.split.size} []" } # arrays
      .split
  end
end
