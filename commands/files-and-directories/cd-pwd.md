# cd 

| args | effects |  
| :--: | ------ |
`.` |current directory |
`..`  | parent directory |
`../..`  | parents' parent dir |
`-` | the previous dir
`~`  | the $HOME dir
`~jon` | jon’s $HOME

If the directory you want to change to has spaces in its name, you should either surround the path with quotes (`''` or `""`) or use a backslash (`\`) to escape the space:

```shell
cd 'dir name with space'
cd dir\ name\ with\ space
```

`pwd`: print working directory 
