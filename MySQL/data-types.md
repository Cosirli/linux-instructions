## How to choose?

**No universal standards**.

**it depends on your business. business perspective counts**.

## Types

### integer

```
tinyint smallint mediumint int bigint
```

Display width (deprecated, combined with `ZEROFILL`)

### floating number

```
float(M,D) double(M,D) deprecated
```

### fixed point number

```
decimal(M,D) M: total digits. D: num of digits for fractional part
```

9 digits corresponds to 4 bytes in storage.

### string

```
char (0 ~ 255 bytes)
varchar (0 ~ 65535 bytes)

```

### boolean

```
boolean
```

### enum

```sql
alter table student modify gender enum('man','woman','?','gay','les');
```

Storage: Integer starting from 1.

### set

```sql
alter table student hobby set('CS', 'Math', 'MBA', 'PHY', 'ECO');
```

Storage: bitmask.

### time

```
datetime (YYYY-MM-DD hh:mm:ss) timestamp
```
