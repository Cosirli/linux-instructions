# double dash
The special argument `--` forces an end of option-scanning, a general shell trick used to signify the end of options, and any subsequent arguments should be treated strictly as positional arguments, **not** as options.

For example, in many commands like ls, grep, or rm, you could use -- to handle filenames that might start with a -, thus avoiding confusion with options.


