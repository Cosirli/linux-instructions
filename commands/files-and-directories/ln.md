# ln
  create link files: hard link (default) and symbolic link (using `-s`)


## Hard link   
A hard link is a **directory entry** that associates a name with a file. Therefore, each file must have at least one hard link (see [Ref count](#reference-counting)). Creating *additional hard links* for a file makes the contents of that file accessible via other paths (hard links). This causes an alias effect: a process can open the file by any one of its paths and change its content.

**Hard links separate entries from physical data.** To access the data, a user only have to specify the name of any existing link; the operating system will resolve the position of actual data.

### Reference counting

Most filesystems that support hard links use ref counting. The system maintains a *counter* that keeps track of the number of hard links pointing to the data. When a hard link is created/removed, the counter increments/decrements. When its value reaches 0, the operating system frees the logical data section (not considering undeletion).

### inode

The inode (index node) is a data structure that describes a file-system object such as a file or a directory. storing the attributes and disk-block locations of that object's data. These attributes may include metadata as well as ownership and permission data. 

each is assigned the same Inode value as the original, all reference the same file location.   
  have actual file contents if original file is removed, moved or renamed, the link will still show the content of the file   


### Limits/Constraints
1. *Cannot create additional hard links to directories on most systems.*
<font size="-1">Every directory is a special file on many systems, containing a list of filenames. Hence, multiple hard links to directories are possible, which could result in a ***circular directory structure*** rather than a tree structure.</font> 


2. *Cannot create in a different filesystem or partition*  


## Symbolic/Soft link
A soft link or “shortcut” to a file is not a direct link to the data itself, but rather a **reference** to a hard link or another soft link.
each contains a separate Inode value pointing to the original file  
Like a pointer, it stores the path, not the actual contents, so if original file is removed or renamed, the link becomes dangling  
Rough understanding: size of the soft link equals the length of the path of the original file (in bytes)   

2 options about updating an existing link   
`-i`: The interactive mode --- asks you if you want to overwrite the existing link.    
`-f`: The force mode --- updates the existing link without any confirmation.  



## Code

```bash
ln -s file f-sym
ln file f-hard
```



