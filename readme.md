# Dx Datastore

Dx is an semi-structured in-memory datastore with copy-on-write semantics for
fast concurrent access.  Records are schema-less name-value pairs that are
grouped together into buckets.  Each record must have an integer `id` field
that is unique within the bucket.

Mutations to a store are handled by a writer instance which buffers a set of
changes and then produces a new store copy.  The backing data is held in
persistent data structures for efficient reuse of unmodified data and to make
mutations thread safe.