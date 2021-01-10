require "phelix"

Phelix.new(Phelix.tokenize ARGF.gets_to_end).evaluate
