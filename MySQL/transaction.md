### Transaction

Feature: ACID

- Atomicity
- Consistency
- Isolation
- Durability

```sql
start transaction;
savepoint rollback_point;
rollback to rollback_point;
commit;
```

```sql
start transaction;

rollback;
```
