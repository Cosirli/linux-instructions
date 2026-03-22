## Services

```bash
net start mysql57
net stop mysql57
```

## Setup

### Create `data` directory

```bash
mysqld --initialize-insecure --user=root
```

### Character encoding issues

Reasons: MySQL uses `latin1` by default, which could cause some encoding issues. Your terminal's configs could also cause encoding issues.

For _Windows Terminal_ and fresh-installed MySQL, it shows that

```text
mysql> show variables like "char%";
+--------------------------+---------------------------------------------------------+
| Variable_name            | Value                                                   |
+--------------------------+---------------------------------------------------------+
| character_set_client     | cp850                                                   |
| character_set_connection | cp850                                                   |
| character_set_database   | latin1                                                  |
| character_set_filesystem | binary                                                  |
| character_set_results    | cp850                                                   |
| character_set_server     | latin1                                                  |
| character_set_system     | utf8                                                    |
| character_sets_dir       | C:\Program Files\MySQL\MySQL Server 5.7\share\charsets\ |
+--------------------------+---------------------------------------------------------+
8 rows in set (0.00 sec)
```

Terrible! CJK characters will be glibberish.

#### Quick fix

```sql
set names utf8mb4
```

`names` is shortcut for `character_set_{results,client,connection}`. Now if the database uses utf8, it is fixed.

Some videos say `character_set_client/results` configured to UTF-8 solves the problem (to be verified)

#### Configure your terminal emulator

For a permanent resolution, let's configure Windows Terminal first by

```bash
chcp 65001   # use UTF-8
```

Now, it gets nicer. For further convenience, write as configs. (MSYS2 `.bashrc`, pwsh/cmd startup command)

```sql
mysql> show variables like "char%";
+--------------------------+---------------------------------------------------------+
| Variable_name            | Value                                                   |
+--------------------------+---------------------------------------------------------+
| character_set_client     | utf8                                                    |
| character_set_connection | utf8                                                    |
| character_set_database   | latin1                                                  |
| character_set_filesystem | binary                                                  |
| character_set_results    | utf8                                                    |
| character_set_server     | latin1                                                  |
| character_set_system     | utf8                                                    |
| character_sets_dir       | C:\Program Files\MySQL\MySQL Server 5.7\share\charsets\ |
+--------------------------+---------------------------------------------------------+
```

Note that:

- `character_set_server`: Default encoding for new databases
- `character_set_database`: Encoding for the current database

  Other resolutions (**Use at your own risk**): The "Beta UTF-8" option may solve the problem, but it puts your Windows at risk in that text files in many softwares, like Visual Studio, would be ruined (as it used to happen, on my laptop).

#### Configure MySQL

Permanent solution:

Edit `my.ini` in `C:\ProgramData\MySQL\MySQL Server 5.7`

Under `[mysql]` and `[client]:

```
default-character-set=utf8mb4
```

Under `[mysqld]`:

```
character-set-server=utf8mb4
collation-server=utf8mb4_general_ci
```

## Client

## DDL

### Database

```sql
show databases;
```

**Create**

`database` is equivalent to `schema`

```sql
create database `stu` charset=utf8mb4;
create database if not exists `stu` default charset utf8mb4;
create database if not exists teacher
character set utf8mb4;
```

**Drop**

```sql
drop database if exists stu;
drop database if exists`database`;
```

**Show** Create SQL

```sql
show create database stu;
```

**Alter**

Alter attributes

```sql
alter database `stu` charset=gdb
```

### Table and field

Specify the database to use and show tables

```sql
use stu;
select database();
show tables;
```

**Create**

Consider:

- Referential integrity
- Foreign reference
- default? NULL?

```sql
mysql> create table if not exists teacher(
    -> id int auto_increment primary key comment 'the primary key of the teacher',  # code comment
    -> name varchar(30) not null comment 'the name of the teacher', -- code comment
    -> phone varchar(20) default '???' comment 'phone number of teacher', /* block comment */
    -> address varchar(100) default 'unknown' comment 'home address of teacher'
    -> )engine=innodb;
```

`auto_increment` **must be key**;

Question: what is innodb?

**description - table structure**

```sql
desc <table-name>;
```

**Drop**

```sql
drop table if exists foo, bar;
```

**Alter**

Synopsis

```sql
alter table <table-name> add/modify/change/rename to/drop ...
```

Add field.

```sql
alter table <table-name> add <field-name> <field-type> <location>;
alter table student add gender int(1) after `name`;
```

Drop field.

```sql
alter table <table-name> drop <field-name>;
```

Change field name/type.

```sql
alter table <table-name> change <old-name> <new-name> <new-type>;
```

Modify field type (cannot rename)

```sql
alter table <table-name> modify <field-name> <new-type> comment <new-comment> after <field-name>;
alter table teacher modify name varchar(40) comment "teacher's name" first;
```

Rename table

```sql
alter table <old-table-name> rename to <new-table-name>
```

### About Primary key

Primary key is unique and cannot be NULL.

**Why needed?**

- Data integrity. Must-have
- Unique identifier
- Convenience and acceleration for Query

Primary key can have multiple fields (called **Composite primary key**)

Primary key can be altered. Example:

```sql
alter table t_8 add primary key (id, name);
alter table t_8 drop primary key;
```

### Unique

Unique in the table. Can be composite.

```sql
alter table t_8 add unique (name):
alter table t_8 drop index name;
```

```sql
alter table t_2 add unique index uk_name (name,cn_name);
alter table t_2 drop index uk_name;
```

### Foreign key

A field / collection of fields that refers to the Primary Key in another table.

```sql
mysql> create table stu(
    -> stuId int(4) primary key,
    -> name varchar(20));

mysql> create table eatery(
    -> id int primary key,
    -> money decimal(17,4),
    -> stuId int(4),
    -> foreign key (stuId) references stu(stuId));

-- The method above creates a constraint named eatery_ibfk_1 by default
-- To rename it, delete and create a new one
alter table eatery drop foreign key eatery_ibfk_1;
alter table eatery add constraint fk_eatery_stu_stuId foreign key (stuId) references stu(stuId);
```

#### Foreign key operations

- RESTRICT (no action, default behavior)
- SET NULL
- CASCADE

```sql
-- To modify the operation, first drop the old foreign key, then:
mysql> alter table eatery add
    -> foreign key (stuId) references stu(stuId)
    -> on update cascade on delete set null;
```

#### Don't use foreign keys

In high-concurrency environments, enterprises don't use foreign keys. Why?

1. Performance. Validation (check parent) multiplies I/O overhead
2. Sharding Barrier. Impossible for distributed systems
3. Cascading catastrophes

## DML - data manip

**Create/Insert**

```sql
insert into teacher (id, name, address) values(NULL, 'Tom', default);
insert into teacher values(NULL, 'Tom_1', NULL, default),(NULL, 'Jerry_1', NULL, default);
```

**Delete**

```sql
delete from teacher where age>30;
```

**Empty**

If use delete:

- Inefficiency: iterates over the table
- if `auto_increment` set, primary key continues to increment

```sql
truncate table teacher;
```

**Update**

```sql
update teacher set name='Frank', address='Vancouver' where id=1 or phone='1234';
```

##
