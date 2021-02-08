require "big"
require "phelix/builtins"
require "phelix/err"
require "phelix/core_ext/*"

class Phelix
  alias Num = BigInt
  alias Str = String
  alias Val = Bool | Char| Fun | Map | Num | Str | Vec | Err
  alias Vec = Array(Val)
  alias Map = Hash(Val, Val)
  alias Fun = self | (Vec -> Vec)

  enum Type
    Char; Cmd; Fun; Map; Num; Str; Sym; Vec; Word
  end

  record Insn, t : Type, v : Val

  @@now = "main"
  @@ret = ""
  @@scope = [] of String
  @@locals = {} of Array(String) => Hash(String, Val)
  @@strings = [] of String
  @@cmds = [] of String

  class_getter env = {} of String => Fun, fatal = true

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

  @infix : String?

  def parse
    while tok = @tokens.shift?
      next @@env[tok.rchop] = find ";", /:$/ if tok[-1] == ':'

      @insns << Insn.new *case
      when tok[/^-?\d+$/]?
        {Type::Num, tok.to_big_i}
      when tok == "\0"
        {Type::Str, @@strings.shift}
      when tok == "\a"
        {Type::Cmd, @@cmds.shift}
      when tok[0] == '\''
        {Type::Sym, tok.lchop}
      when tok[0] == '#'
        {Type::Char, Phelix.parse_char tok}
      when tok == "("
        {Type::Fun, find ")", "("}
      when tok == "["
        {Type::Vec, find("]", "[").call}
      when tok == "{"
        vec = find("}", "{").call
        if vec.size.odd?
          m = Map.new vec.pop
        else
          m = Map.new
        end
        vec.each_slice 2 { |(k, v)| m[k] = v }
        {Type::Map, m}
      else
        if fn = tok[/<(.+)>/, 1]?
          next @infix = fn
        end
        {Type::Word, tok}
      end

      if fn = @infix
        @infix = nil
        @insns << Insn.new Type::Word, fn
      end
    end
  end

  def call(stack = Vec.new)
    @insns.each do |insn|
      break @@ret = "" if @@ret == @@scope[0]?
      insn.v.as(Phelix).close if insn.v.is_a? Phelix

      case insn.t
      when Type::Num, Type::Str, Type::Char, Type::Fun
        stack << insn.v
      when Type::Map, Type::Vec
        stack << insn.v.dup
      when Type::Sym
        stack << @@env.fetch word = insn.v, word
      when Type::Cmd
        stack << `#{insn.v}`
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
      .gsub(/# .*/, "") # strip comments
      .gsub(/"([^"]*)"/) { @@strings << $1; '\0' } # carve out strings
      .gsub(/`([^`]+)`/) { @@cmds << $1; '\a' } # carve out commands
      .gsub(/[;)(}{\][]/, " \\0 ") # padding to simplify parsing
      .split
  end

  def self.parse_char(tok)
    return tok[1] if tok[1] != '\\'

    if c = tok[2]?
      case c
      when 'a'; '\a' when 'b'; '\b' when 'e'; '\e' when 'f'; '\f'
      when 'n'; '\n' when 'r'; '\r' when 't'; '\t' when 'v'; '\v'
      when 'u'; tok[3..].to_i(16).chr
      when '\\'; '\\'
      else c
      end
    else
      abort "unterminated character literal"
    end
  end

  def self.[](code)
    new tokenize code
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
