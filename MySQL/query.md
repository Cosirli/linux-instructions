## Single-table

```sql
select
```

### SELECT

```sql
SELECT field1 AS alias1, field2 AS alias2 FROM
```

### DUAL

A dummy table. Designed to satisfy SQL syntax.

```sql
select 2*7 from dual;
```

In MySQL, we can omit `from dual` if we just want to do some calc, call some func.

### Literals, aliases and Calculations

Print raw strings (USE `' '` FOR TEXT!! ).

```sql
select 'Nonsense' as silly;
```

Simple calculations

```sql
select pow(2,3), 2*7 as result;
select ceil(12.5), floor(12.5), round(12.45, 1);
```

### WHERE

MySQL uses three-valued logic: `TRUE`, `FALSE` and `UNKNOWN`. MySQL doesn't support `is unknown`, we use `IS NULL`, `IS NOT NULL`

Logic expressions

- can be quoted
- short-circuit evaluation

#### Comparison operators

```
=
!= / <>
```

Null-safe equal: `<=>`

#### Logical operators

```
NOT / !
OR / ||
AND / &&
XOR
```

#### IN

filter values in a list or subquery

```sql
`address` IN ('Beijing', 'London', 'Paris')
```

#### BETWEEN ... AND ...

filter values within range, inclusive

```sql
`age` between 20 and 30    /* [20, 30] */
```

#### IS NULL / IS NOT NULL

The only way to check NULL values that returns `TRUE` or `FALSE`. Any other comparison to `NULL` returns `UNKNOWN`

```sql

```

#### LIKE

Pattern matching.

- `%`: Represents zero, one, or multiple characters.
- `_`: Represents a single character.

#### REGEXP

regex.

### GROUP BY ... HAVING ...

It happens after `where`. Execution order explained:

- Bucketing: sorting rows into buckets based on certain field
- Aggregating: perform math (the aggregate function) on each bucket separately
- Filtering: decides which buckets to keep after the buckets are full

`WHERE` filters data in the original table. `HAVING` filters results **after** grouping, can use aliases, can use aggregate functions.

Selected

```sql
select <aggregate_func>(field1), field2 group by field2 having <some-condition>
```

#### group_concat()

Concatenate values in a group.

Synopsis:

```sql
GROUP_CONCAT([DISTINCT] expr [,expr ...]
             [ORDER BY {unsigned_integer | col_name | expr} [ASC | DESC] [,col_name ...]]
             [SEPARATOR str_val])

```

Example: select student's distinct addresses grouped by gender, separated by ' / '

```sql
select group_concat(distinct addr separator ' / ')
	from stu group by gender;
```

### ORDER BY

Ascending `ASC`, descending `DESC`

```sql
order by entrydate asc, age desc
```

### LIMIT & OFFSET

For pagination

- m: how many rows to skip (in other words, starting from m, where m counts from 0)
- n: how many rows to return

```sql
LIMIT n   -- starting point omitted
LIMIT m, n
LIMIT n OFFSET m
```

### `DISTINCT` and `ALL`

Placed after `SELECT`. The default is `ALL`

```sql
select all from ...
select distinct from ...
```

### Deal with `NULL`

1. **Logic**: Any direct comparison with `NULL`, including comparison operators and `IN`, results in `UNKNOWN`, except The Null-Safe Equality Operator `<=>`:

Don't write:

```
id != NULL      --> UNKNOWN
id IN (1, NULL) --> UNKNOWN
```

Write:

```
id IS NULL
id IS NOT NULL
1 <=> NULL      --> FALSE
NULL <=> NULL   --> TRUE
```

2. **Arithmetics and concatenation**: Any arithmetic and string concat operation results in `NULL`.

3. **Aggregate functions**: most of them ignores it, like count, avg, sum, min, max. for example:
   - `COUNT(*)` and `COUNT(1)` returns the number of all records
   - `COUNT(field1)` ignores `NULL` rows

4. **Order by**: `NULL` is regarded as the lowest value.

#### Useful functions

Use `IFNULL(val, default_val)` to provide a default value if `val` is NULL.

```
CONCAT('Hello', IFNULL(name, 'default name here'))
```

Use `COALESCE(val1, val2, ...)` to return the first non-null value in a list. It's an advanced version of `IFNULL` used likewise.

### Aggregate functions

count, avg, sum, min, max, variance, std, ...

json

```sql
JSON_OBJECTAGG(id, name)
JSON_ARRAYAGG(JSON_OBJECT('id', id, 'name', name)),
```

### Window functions

MySQL 8.0+

## Multi-Table

### JOIN

#### cross join (Cartesian Product)

Every possible combinations of rows

```sql
select * from t1 cross join t2;
select * from t1, t2;
```

You can add a `ON` clause in MySQL as well, but why not use `inner join`? More portable, safe (syntax check) and intent clear

#### inner/left/right and `JOIN ... ON ...`

Filter records based on the `ON` clause

- Inner join (内连接): strict matches only
- Left join: `A LEFT JOIN B` returns (all of A's cols) + (B's matches or NULL)

```sql
select stu.name, grade.OS, grade.ICS from stu INNER JOIN grade
ON stu.id = grade.stuId;
```

Self-join is possible by name aliases, like:

```sql
SELECT e.name AS 'Employee', l.name AS 'Leader'
FROM emp AS e
LEFT JOIN emp AS l
ON e.leader_id = l.id
```

#### Natural join and `JOIN ... USING ...`

Natural join: Auto-match fields with the same name. Easy to write but results in **BRITTLE schema**. If no common fields, it behaves the same as cross join.

Using: specify a list of column names.

```sql
select stu.name, grade.OS, grade.ICS from stu join grade using (stuId);
```

### UNION

When to union?

- same number of cols, each with matched type
- field be meaningful and corresponds

The default `UNION` is `UNION DISTINCT`. You can explicitly write `UNION ALL`

Note that:

- The final result headers are inherited from the first `SELECT`
- Use parentheses. If there's no parenthesis, by default:
  - `WHERE` and `GROUP BY` are local and apply to the nearest `SELECT`.
  - `ORDER BY` and `LIMIT` are global, and apply to the entire result

```sql
(select age, gender from stu)
union all (select age, gender from teacher)
where age>18 order by age desc limit 0,10
```

## Subquery

### `IN` and `NOT IN`

```sql
select name from stu where id NOT IN (select stuId from score where score>=90);
```

### `EXISTS` and `NOT EXISTS`

Example: If there exists one student who scores 100, all students shall gain some bonus...

```sql
select name from stu where id EXISTS (select stuId from score where score=100);
```

### Scalar subquery:

```sql
select (select age from emp limit 0,1) as 'min age';
-- if the subquery returns an empty set, the parent query returns NULL
```

## Execution order

```sql
FROM
	emp
JOIN
ON
WHERE
	age BETWEEN 30 AND 50
GROUP BY      -- aggregate functions run after grouping
	gender
HAVING
	`Avg age` > 31 IS TRUE
SELECT
DISTINCT
ORDER BY
    `Avg age` DESC
LIMIT 2 OFFSET 0
```

`WHERE` cannot use aliases, according to the exec order

`HAVING` happens before `SELECT` but can use aliases. It's just a MySQL extension.

If there is `UNION`, it along with additional filters executes after the `SELECT` clauses that it unions finish execution independently.

## "Types" and operations

**Scalar**: 1 x 1 cell, used in SELECT, compare, ...

**Vector**: IN

**Matrix**: IN, FROM

`SELECT` is followed by a _projection list_ that could only contain expressions that evaluate to a scalar.

**Scalar subquery**: `SELECT <expr1>, ...`, where `<expr>` must be a scalar. Returns `NULL` if the `<expr>` is empty set.

```
mysql> select (select id from stu limit 0) as 'expr';
+------+
| expr |
+------+
| NULL |
+------+
```

## Exercises

Select all employees, that has a leader, age in [30, 50], grouped by gender, showing "id: name", count and avg age, avg age > 31, order by avg age, showing the first 2 rows

```sql
SELECT
	gender,
	GROUP_CONCAT(CONCAT(id, ': ', name)) AS 'emp',
	count( 1 ) AS '人数',
	AVG( age ) AS 'Avg age'
FROM
	emp
WHERE
	age BETWEEN 30 AND 50 && leader_id IS NOT NULL
GROUP BY
	gender
HAVING
	`Avg age` > 31 IS TRUE
ORDER BY
    `Avg age` DESC
LIMIT 0, 2
```
