
# An Index is some query over the various models that gets named and cached like how the queries work.
#
# The motivating example is the way I originally did `types` back in `hazel`, I just munged enums, traits, and structs
# together in one big query, but this is untenable from the parsing perspective. So instead in this version I did
# structs very completely on it's own, and next will be enums and traits similarly. I still want to be able to query
# across the three as a unit, so an index is necessary. The index takes some block that does the query across the model
# and returns an Enumerable of results, the Index caches that Result and manages clearing that cache (manually for now).
#
# Eventually `tabitha` should be live-updating, so the cache logic will get more complicated, but for now I need to
# essentially do one-shot queries so caching isn't a huge issue.
#
# Indices derive from this class like Queries derive from Query
#
# Indices can reference other Indices in the query as well, and also should have some tools for filtering results.
