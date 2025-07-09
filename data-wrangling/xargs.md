# xargs

`xargs` accepts input from stdin and converts it into an argument list for a specific command.

```bash
find . -type f -name '*.md' | xargs ls -dl
```

## dealing with "funny" filenames
Unix-like systems allow leading dash, embedded spaces, dollar sign, exclaimation mark... and even newlines in filenames!

To deal with such filenames, `find` provides the action `-print0` to produce null-separated output, `xargs` provides the `-0` (`--null`) option to accept null-separated output.


```bash
find . -type f -print0 | xargs -0 ls -dl
```
