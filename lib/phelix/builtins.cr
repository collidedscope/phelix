class Phelix
  macro raise(message)
    e = Err.new {{message}}
    if @@fatal
      abort e
    else
      return s << e
    end
  end

  macro fail(wanted, got)
    raise "wanted #{alias_for {{wanted}}} for #{@@now}, got #{{{got}}.inspect}"
  end

  macro check(val, type)
    begin
      {{val}}.as {{type}}
    rescue TypeCastError
      fail {{type}}, {{val}}
    end
  end

  macro arity(need)
    if s.size < {{need}}
      raise "need at least #{{{need}}} values for #{@@now}, have #{s.size}"
    end
  end

  macro get(type)
    val = s.pop
    check val, {{type}}
  end

  macro get(*types)
    vals = s.pop {{types.size}}
    {
      {% for t in types %}
        (v = vals.shift; check(v, {{t}})),
      {% end %}
    }
  end

  @@docs = {} of String => {String, Int32}
  @@sources = {} of String => String

  macro defb(word, &body)
    {% if flag?(:ocs) %}
      @@docs[{{word}}] = {__FILE__, __LINE__}
    {% else %}
      @@env[{{word}}] = -> (s: Vec) { -> {{body}}.call; s }
      @@sources[{{word}}] = {{body.stringify}}
    {% end %}
  end
end

require "phelix/builtins/*"
