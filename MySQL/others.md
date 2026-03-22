## Procedure

存储过程：
模块化设计

```sql
delimiter //
create procedure proc()
begin
start transaction;
update wallet set balance=balance+50;
-- ...
commit;
end //

delimiter ;
call proc();

show create procedure proc;
show procedure status \G;
```

## Interesting functions

```sql
rand() -- [0,1]
round()
ceil()
floor()
```

```sql
substring(str, start, len) -- start counts from 1
concat(str1, str2)
lcase(str)
ucase(str)
left(str, num)
right(str, num)
```

```sql
now()
unix_timestamp()
select year(now()) Year, month(now()) Month, day(now()) Day;
```

```sql

```
