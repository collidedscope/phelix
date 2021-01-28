class Phelix
  macro raise(message)
    e = Err.new {{message}}
    if @@fatal
      abort e
    else
      return s << e
    end
  end

  TYPES = [Num, Str, Val, Vec, Map, Fun]

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

  macro dbi(word, *types, &body)
    {% if flag?(:ocs) %}
      docs[{{word}}] = {__FILE__, __LINE__}
    {% elsif types.empty? %}
      env[{{word}}] = -> (s: Vec) { -> {{body}}.call; s }
    {% else %}
      env[{{word}}] = -> (s: Vec) {
        arity {{types.size}}
        vals = s.pop {{types.size}}
        Proc({{*types}}, Nil).new {{body}}.call *{
          {% for t in types %}
            check(vals.shift, {{t}}),
          {% end %}
        }
        s
      }
    {% end %}
    sources[{{word}}] = {{types.stringify}} + ' ' + {{body.stringify}}
  end
end

require "phelix/builtins/*"
