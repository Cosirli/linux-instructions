***Abstraction layers* are the alpha and omega in the design of complex architectures.** The Linux *Storage Stack* is an excellent example of well-coordinated layers. Access to storage media is abstracted through a unified interface, without sacrificing functionality. 

https://www.admin-magazine.com/Archive/2016/31/Linux-Storage-Stack   

In the storage stack context, the end users are typically normal applications (userspace programs/applications). The first component with which Linux programs interact when processing data is the *virtual filesystem (VFS)*. **Only through the VFS is it possible to invoke the same system calls for different filesystems on different media.** Using VFS, for example, a file is transparently copied for the user from an ext4 to an ext3 filesystem using the `cp` command.

