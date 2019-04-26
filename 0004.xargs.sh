#!/bin/bash

# #########################################################################################
# xargs命令
#   xargs命令是给其他命令传递参数的一个过滤器，也是组合多个命令的一个工具。它擅长将标准输入数据转换成命令行参数，
# xargs能够处理管道或者stdin并将其转换成特定命令的命令参数。xargs也可以将单行或多行文本输入转换为其他格式，
# 例如多行变单行，单行变多行。xargs的默认命令是echo，空格是默认定界符。这意味着通过管道传递给xargs的输入将会
# 包含换行和空白，不过通过xargs的处理，换行和空白将被空格取代。xargs是构建单行命令的重要组件之一。
# #########################################################################################

# xargs用作替换工具，读取输入数据重新格式化后输出。
# 测试文件:
# [airy]$ cat test.txt
# [airy]$ a b c d e f g
# [airy]$ h i j k l m n
# [airy]$ o p q
# [airy]$ r s t
# [airy]$ u v w x y z

# 多行输入单行输出
cat test.txt | xargs    # [airy]$ a b c d e f g h i j k l m n o p q r s t u v w x y z

# -n选项多行输出
cat test.txt | xargs -n3
# [airy]$ a b c
# [airy]$ d e f
# [airy]$ g h i
# [airy]$ j k l
# [airy]$ m n o
# [airy]$ p q r
# [airy]$ s t u
# [airy]$ v w x
# [airy]$ y z

# -d选项可以自定义一个定界符
echo -n "nameXnameXnameXname" | xargs -dX
# [airy]$  name name name name
echo -n "nameXnameXnameXname" | xargs -dX -n2
# [airy]$ name name
# [airy]$ name name


# 假设一个命令为 sk.sh 和一个保存参数的文件arg.txt：
#!/bin/bash
#sk.sh命令内容，打印出所有参数。

# echo $*
# arg.txt文件内容：

# cat arg.txt
# aaa
# bbb
# ccc

# xargs的一个选项-I，使用-I指定一个替换字符串{}，这个字符串在xargs扩展时会被替换掉，当-I与xargs结合使用，每一个参数命令都会被执行一次：
cat arg.txt | xargs -I {} ./sk.sh -p {} -l
# -p aaa -l
# -p bbb -l
# -p ccc -l

# 复制所有图片文件到 /data/images 目录下：
ls *.jpg | xargs -n1 -I cp {} /data/images

# xargs结合find使用
# 用rm 删除太多的文件时候，可能得到一个错误信息：/bin/rm Argument list too long. 用xargs去避免这个问题：
find . -type f -name "*.log" -print0 | xargs -0 rm -f

# xargs -0将\0作为定界符。
# 统计一个源代码目录中所有py文件的行数：
find . -type f -name "*.py" -print0 | xargs -0 wc -l

# 查找所有的jpg 文件，并且压缩它们：
find . -type f -name "*.jpg" -print | xargs tar -czvf images.tar.gz

# 查看文件类型
find -type f -name "*.py" -print | xargs file

# 假如你有一个文件包含了很多你希望下载的URL，你能够使用xargs下载所有链接：
cat url-list.txt | xargs wget -c
