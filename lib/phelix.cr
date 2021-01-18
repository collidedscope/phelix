require "big"
require "phelix/builtins"
require "phelix/err"

class Phelix
  alias Num = BigInt
  alias Str = String
  alias Val = Bool | Fun | Map | Num | Str | Vec | Err
  alias Vec = Array(Val)
  alias Map = Hash(Val, Val)
  alias Fun = self | (Vec -> Vec)

  enum Type; Fun; Map; Num; Str; Vec; Word end

  record Insn, t : Type, v : Val

  @@now = "main"
  @@env = {} of String => Fun
  @@scope = [] of String
  @@locals = {} of Array(String) => Hash(String, Val)
  @@strings = [] of String

  def initialize(@tokens = [] of String, @insns = [] of Insn)
    @closed = {} of String => Val
    parse if @insns.empty?
  end

  macro find(close, reopen)
    fn = [] of String
    nesting = 0

    while t = @tokens.shift?
      if t == {{close}}
        break if nesting.zero?
        nesting -= 1
      end
      nesting += 1 if {{reopen}} === t
      fn << t
    end

    Phelix.new fn
  end

  def parse
    while tok = @tokens.shift?
      next @@env[tok.rchop] = find ";", /:$/ if tok[-1] == ':'

      @insns << Insn.new *case
      when tok[/^-?\d+$/]?
        {Type::Num, tok.to_big_i}
      when tok == "\0"
        {Type::Str, @@strings.shift}
      when tok == "("
        {Type::Fun, find ")", "("}
      when tok == "["
        {Type::Vec, find("]", "[").call}
      when tok == "{"
        vec = find("}", "{").call
        abort "map literal must have even elements" if vec.size.odd?
        m = Map.new false
        vec.each_slice 2 { |(k, v)| m[k] = v }
        {Type::Map, m}
      else
        {Type::Word, tok}
      end
    end
  end

  def call(stack = Vec.new)
    @insns.each do |insn|
      insn.v.as(Phelix).close if insn.v.is_a? Phelix

      case insn.t
      when Type::Num, Type::Str, Type::Fun
        stack << insn.v
      when Type::Map, Type::Vec
        stack << insn.v.dup
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

  def close
    @@locals.each do |_, vars|
      vars.each do |name, val|
        @closed[name] = val
      end
    end
  end

  def resolve_local(word)
    if closed = @closed[word]?
      return closed
    end

    scope = @@scope.dup

    loop do
      if locals = @@locals[scope]?
        if val = locals[word]?
          return val
        end
      end
      scope.pop { return Err.new "unknown word '#{word}'" }
    end
  end

  def inspect(io)
    if name = @@env.key_for? self
      io << name
    end
    insns = @insns.map { |i|
      case i.t
      when Type::Fun ; i.v.inspect
      when Type::Word; @@env.fetch(i.v) { resolve_local i.v }.inspect
      else i.v
      end
    }
    io << "(#{insns.join ' '})"
  end

  def self.tokenize(src)
    src
      .gsub(/#.*/, "") # strip comments
      .gsub(/"([^"]*)"/) { @@strings << $1; '\0' } # carve out strings
      .gsub(/[;)(}{\][]/, " \\0 ") # padding to simplify parsing
      .split
  end

  def self.[](code)
    new tokenize code
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
    Proc => :Builtin
  }

  def self.alias_for(type)
    ALIASES.fetch type, type
  end
end

struct Proc
  def inspect(io)
    io << Phelix.env.key_for self
  end
end
