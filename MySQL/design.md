## Normal Forms

### Atomicity

Field should be individible: make sure the atomicxity of each field

### No Partial Dependency

All non-key attributes must be **fully dependent** on the whole primary key

P.S.: One table stores one kind of data. Don't include unrelated nonsense

### No Transitive Dependency

All non-key attributes must be **directly dependent** on the key

Every column must depend on the key, the whole key, and nothing but the key.

Always BUT Not necessarily. It depends on the demand whether redundency is needed.
