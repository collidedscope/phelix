require "yaml"

docs = {} of String => Hash(String, String)

Phelix.docs.group_by(&.[1][0]).transform_values { |val|
  val.map { |v| {v[1][1], v[0]} }
}.each do |path, fns|
  doc = [] of String
  fns = fns.to_h

  vocab = File.basename path, ".cr"
  docs[vocab] = {} of String => String

  File.open(path) do |f|
    f.each_line.with_index do |line, i|
      case line
      when /^\s*#/
        doc << line.split("# ")[1]
      when ->(s: String) { doc[0]? }
        if fn = fns[i + 1]?
          docs[vocab][fn] = doc.join '\n'
        end
        doc.clear
      end
    end
  end
end

File.write "docs.yaml", docs.to_yaml
