## Why?

Data security

Less complicated query

```sql
create view vw_stu as
select `name`, `OS` from student inner join score on student.id=score.stuId;
```

```sql
show create view vw_stu;
show table status where comment='view' \G
```
