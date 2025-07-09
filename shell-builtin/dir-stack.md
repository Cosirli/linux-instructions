

# Bash Directory Stack Builtins
dirs, pushd, and popd commands maintain a history of the directories visited using a stack.
## dirs
Show the directory stack
- `dirs -l`: use full pathnames
- `dirs +N`: display the N-th dir counting from the left, starting with zero.
- `dirs -N`: display the N-th dir counting from the right, starting with zero.

## pushd
`pushd new_dir` pushes current dir onto stack, and `cd`s to `new_dir`.

## popd
`popd` pops the top dir from the stack and `cd`s to it.

# Related variables

```bash
$OLDPWD
```
The result of expansion `~-/`, the target of `cd -`

```bash
$PWD
```
The result of expansion `~+/`
