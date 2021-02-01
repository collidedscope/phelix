class Phelix
  macro raise(message)
    e = Err.new {{message}}
    if Phelix.fatal
      abort e
    else
      return s << e
    end
  end

  TYPES = [Bool, Char, Num, Str, Val, Vec, Map, Fun]

  macro fail(wanted, got)
    type = TYPES.select(&.<= {{wanted}}).map { |t| alias_for t }.join " | "
    raise "wanted #{type} for #{@@now}, got #{{{got}}.inspect}"
  end

  macro check(val, type)
    v = {{val}}
    begin
      v.as {{type}}
    rescue TypeCastError
      fail {{type}}, v
    end
  end

  macro arity(need)
    if s.size < {{need}}
      raise "need at least #{{{need}}} values for #{@@now}, have #{s.size}"
    end
  end

  macro get(type)
    check s.pop, {{type}}
  end

  class_getter \
    docs = {} of String => {String, Int32},
    sources = {} of String => String

  class Dispatch
    alias Type = (Array(Phelix::Val) | Map | Str).class | (Vec | Str).class |
      Num.class | Map.class | Fun.class | Val.class | Str.class | Vec.class |
      Char.class | (Char | Str).class | Bool.class
    alias Sig = Array(Type)

    class_getter table = {} of String => Hash(Sig, Fun)

    def initialize(@word : String)
    end

    def call(s)
      if match = @@table[@word].find { |types, _|
        types.zip?(s.last types.size).all? { |a, b| a === b }
      }
        match[1].call s
      else
        Phelix.raise "no matching overload for #{@word}; valid arities are: #{@@table[@word].keys}"
      end
    end
  end

  macro dbi(word, *types, &body)
    {% if flag?(:ocs) %}
      docs[{{word}}] = {__FILE__, __LINE__}
    {% elsif types.empty? %}
      env[{{word}}] = -> (s: Vec) { -> {{body}}.call; s }
    {% else %}
      # TODO: Find out why `sig` can't just be `{{types}}.to_a`.
      sig = [] of Dispatch::Type
      {% for t in types %} sig << ({{t}}); {% end %}

      Dispatch.table[{{word}}] ||= {} of Dispatch::Sig => Fun
      Dispatch.table[{{word}}][sig] = -> (s: Vec) {
        arity {{types.size}}
        vals = s.pop {{types.size}}
        Proc({{*types}}, Nil).new {{body}}.call *{
          {% for t in types %}
            check(vals.shift, {{t}}),
          {% end %}
        }
        s
      }

      case Dispatch.table[{{word}}].size
      when 1
        env[{{word}}] = Dispatch.table[{{word}}][sig]
      when 2
        %disp = Dispatch.new {{word}}
        env[{{word}}] = -> (s: Vec) { %disp.call s; s }
      end
    {% end %}
    sources[{{word}}] = {{types.stringify}} + ' ' + {{body.stringify}}
  end
end

require "phelix/builtins/*"
