#!/bin/bash

# #########################################################################################
# find命令的一些常见用法, 详细说明请: man find
# 常用的选项:
# -name filename                按照文件名查找文件
# -perm                         按照文件权限来查找文件
# -user username                按文件属主来查找
# -group groupname              按照文件所属的组来查找文件
# -mtime -n +n                  按照文件的更改时间来查找文件，-n表示文件更改时间距现在n天以内，+n表示文件更改时间距现在n天以前
# -atime -n +n                  按文件访问时间来查找文件，同上
# -ctime -n +n                  按文件创建时间来查找文件，同上
# -nogroup                      查无有效属组的文件，即文件的属组在/etc/groups中不存在
# -nouser                       查无有效属主的文件，即文件的属主在/etc/passwd中不存
# -type b/d/c/p/l/f             查是块设备、目录、字符设备、管道、符号链接、普通文件
# -size n[c]                    查长度为n块[或n字节]的文件
# -mount                        查文件时不跨越文件系统mount点
# -follow                       如果遇到符号链接文件，就跟踪链接所指的文件
# -prune                        使用这一选项可以使find命令不在当前指定的目录中查找，如果同时使用-depth选项，那么-prune将被find命令忽略。
# -newer file1 ! file2          查找更改时间比文件file1新但比文件file2旧的文件
#
# 另外,下面三个的区别:
# -amin n                       查找系统中最后N分钟访问的文件
# -atime n                      查找系统中最后n*24小时访问的文件
# -cmin n                       查找系统中最后N分钟被改变文件状态的文件
# -ctime n                      查找系统中最后n*24小时被改变文件状态的文件
# -mmin n                       查找系统中最后N分钟被改变文件数据的文件
# -mtime n                      查找系统中最后n*24小时被改变文件数据的文件
# #########################################################################################

# 举例

# 1 使用name选项
# 在$HOME中查找文件名符合*.txt的文件
find ~ -name "*.txt" -print
# 在当前目录及子目录中查找文件名以一个大写字母开头的文件
find -name "[A-Z]*" -print
# 查找文件名字，忽略大小写
find -iname filename
# 查找文件名字，忽略大小写
find -not -iname filename
# 查找除了filename以外的文件, 2中写法
find -not -iname filename
find ! -iname filename
# 查找空文件
find -empty
# 查找5个最大的文件
find -type f -exec ls -s {} \; | sort -n -r | head -5
# 查找5个最小的文件
find -type f exec ls -s {} \; | sort -n | head -5
# 查找5个最小的文件, 排除空文件
find -not -empty -type f -exec ls -s {} \; | sort -n | head -5

# 2 用perm选项
# 在当前目录下查找文件权限位为755的文件
find . -perm 755 -print
# 查找用户有写权限或者组用户有写权限的文件或目录
find . -perm -u+w,g+w

# 3 忽略某个目录
# 如果在查找文件时希望忽略某个目录，因为你知道那个目录中没有你所要查找的文件，那么可以使用-prune选项来指出需要忽略的目录。
# 在使用-prune选项时要当心，因为如果你同时使用了-depth选项，那么-prune选项就会被find命令忽略。 
# 如果希望在$HOME目录下查找文件，但不希望在$HOME/temp目录下查找，可以用：
find $HOME -path $HOME/temp -prune -or -maxdepth 2 -name "*.txt" -print
# 排除多个目录
find $HOME -path $HOME/temp -prune -o -path $HOME/test -prune -o -maxdepth 2 -name "*.txt" -print

# 4 使用user和nouser选项
# 按文件属主查找文件，如在$HOME目录中查找文件属主为airy的文件
find $HOME -maxdepth 1 -user airy
# 为了查找属主帐户已经被删除的文件，可以使用-nouser选项。这样就能够找到那些属主在/etc/passwd文件中没有有效帐户的文件。
# 在使用-nouser选项时，不必给出用户名； find命令能够为你完成相应的工作
find $HOME -nouser -print

# 5 使用group和nogroup选项, 同上

# 6 按照更改时间或访问时间等查找文件
# 查找更改时间在5日以内的文件
find $HOME -mtime -5 -print
# 查找更改时间在3日以前的文件
find $HOME -mtime +3 -print
# 查找一天内被访问的文件 
find $HOME -atime -1 -type f -print 
# 查找一天前被访问的文件 
find $HOME -atime +1 -type f -print
# 查找一天内状态被改变的文件 
find $HOME -ctime -1 -type f -print 　　
# 查找一天前状态被改变的文件 
find $HOME -ctime +1 -type f -print 　　
# 查找10分钟之内状态被改变的文件 
find $HOME -cmin -10 -type f -print

# 7 查找比某个文件新或旧的文件
# 查找更改时间比temp文件新的文件
find $HOME -newer temp -print
# 查找更改时间比temp文件旧的文件
find $HOME ！ -newer temp -print
# 查找比aa.txt新，比bb.txt旧的文件 
find . -newer 'aa.txt' ! -newer 'bb.txt' -type f -print 
# 查找所有在/etc/hosts文件被修改后被访问到的文件
find -anewer /etc/hosts
# 显示在修改文件/etc/fstab之后所有文件状态改变过的文件
find -cnewer /etc/fstab

# 8 使用type选项
# 查找所有的目录
find $HOME -type d -print
# 查找除目录以外的所有类型的文件,包括子目录下的文件
find $HOME ! -type d -print

# 查找符号链接文件
find $HOME -type l -print

# 9 使用size选项
# 查找文件长度大于1M字节的文件
find $HOME -size +1000000c -print
# 查找文件长度恰好为100m的文件
find $HOME -size 100m -print
# 查找长度超过10块的文件（一块等于512字节）
find $HOME -size +10 -print

# 10 使用exec选项
# 查询当天修改过的文件
find $HOME -mtime -1 -type f -exec ls -l {} \;
# 查找到的结果当脚本的参数，并执行脚本
find -name "*.txt" -exec ./my.sh '{}' \;

# 11 mindepth与maxdepth选项
# 在root目录及其1层深的子目录中查找passwd
find -maxdepth 2 -name passwd
# 在第二层子目录和第四层子目录之间查找passwd文件
find -mindepth 3 -maxdepth 5 -name passwd
