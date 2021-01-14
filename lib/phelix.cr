require "big"
require "phelix/builtins"

class Phelix
  alias Num = BigInt
  alias Str = String
  alias Val = Bool | Fun | Map | Num | Str | Vec
  alias Vec = Array(Val)
  alias Map = Hash(Val, Val)
  alias Fun = self | (Vec -> Vec)

  enum Type; Num; Str; Fun; Word end

  record Insn, t : Type, v : Val

  @@now = "main"
  @@env = {} of String => Fun
  @@scope = [] of String
  @@locals = {} of Array(String) => Hash(String, Val)

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
        if fn = @@env[word]?
          @@now = word
          if fn.is_a? Phelix
            @@scope << word
            fn.call stack
            @@locals.delete @@scope
            @@scope.pop
          elsif fn.is_a? Proc
            fn.call stack
          end
        elsif word[0] == '\''
          word = word.lchop
          stack << @@env.fetch word, word
        else
          stack << resolve_local(word).not_nil!
        end
      end
    end

    stack
  end

  def resolve_local(word)
    scope = @@scope.dup

    loop do
      if locals = @@locals[scope]?
        if val = locals[word]?
          return val
        end
      end
      scope.pop { abort "unknown word '#{word}'" }
    end
  end

  def inspect(io)
    io << "#{@@env.key_for self}(#{@tokens.join ' '})"
  end

  def self.tokenize(src)
    src
      .gsub(/#.*/, "") # strip comments
      .gsub(/[)(]/, " \\0 ") # pad parens for easy tokenization
      .gsub(/\[([^\]]+)\]/) { "#{$1} #{$1.split.size} []" } # vectors
      .gsub(/{([^}]+)}/) { "#{$1} #{$1.split.size // 2} {}" } # maps
      .split
  end

  def self.env
    @@env
  end

  ALIASES = {
    Fun => :Fun,
    String => :Str,
    BigInt => :Num,
    Array(Val) => :Vec,
    Hash(Val, Val) => :Map,
  }

  def self.alias_for(type)
    ALIASES.fetch type, type
  end
end

struct Proc
  def inspect(io)
    if builtin = Phelix.env.key_for? self
      io << "builtin##{builtin}(#{Phelix.sources[builtin]})"
    else
      io << self
    end
  end
end
