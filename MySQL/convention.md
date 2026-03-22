## Field constraints

### Mandatory fields

- `id`: must be primary key of type `unsigned bigint`. If the table is standalone (non-distributed), it must `auto_increment`
- `create_time` of type `datetime`, default `current_timestamp`
- `update_time` of type `datetime`, default `current_timestamp on update current_timestamp`

### Type

For true-or-false fields, use `unsigned tinyint(1)`

Never use float or double, use decimal.

### Naming conventions

Use snake case, i.e., lowercase with underscores.

For true-or-false types, POJOs cannot be named `isXxx`, but MySQL fields should be named `is_xxx`

Field name should start with a lowercase letter only. Field name shouldn't contain a uppercase letter, use an underscore to separate.

Table name shouldn't be plural

Primary key: `pk_xxx`

Unique key: `uk_xxx`

Normal Index: `idx_xxx`

### Others

Data redundency is permitted for regular query purposes.

If a table has rows greater than 5 million or takes up space greate than 2 GB.

## Index constraints

Avoid Functions on Indexed Columns, which would invalidate the index.

No leading wildcards: 禁止左模糊/全模糊，如`LIKE '%keyword'`. Use dedicated search engines, like Elasticsearch.

All **business-level unique** fields, even if it includes composite fields, must have a `UNIQUE INDEX`.
Application-level validation and integrity controls are inefficient; without a unique index, dirty data is inevitable

Multi-table queries involving more than 2 tables are prohibited. Corresponding fields must be of the same type.

All columns used in `JOIN` conditions must be indexed to prevent full-table scans.

The use of **Foreign keys** and **Cascading** operations is strictly prohibited.
Data consistency must be maintained at the Application Level

Stored procedures are prohibited. No maintainability, scalability and portability.

For update and delete operations, do query first and check if there's something wrong.

Charset must be utf8

Better not use `IN` operations

When using ORM frameworks (like Spring Data JPA), don't use `*` for `select`
