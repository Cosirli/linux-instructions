### Four Types

Primary key

Unique key

Index

全文索引. Sphinx: 中文索引

```sql
create unique index <index-name> on <table-name> (<field-name>);
alter table <table-name> add index <index-name> (field-name>);
drop index <index-name>;
```
