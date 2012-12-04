
1)
启动mysql.cmd
启动mysql

2)
停止mysql.cmd
停止mysql


3)
heidisql.exe 是一个简单的mysql客户端
"\mysql5.0.90_hz\bin\heidisql.exe"

依赖\mysql5.0.90_hz\bin中的其他文件，不要拷贝到其他路径执行。



========================
mysql 配置总结
 
1：
更改配置文件使mysql的表名不区分大小写
配置文件从  /usr/share/mysql 下拷贝自 my-medium.cnf 到 /etc/my.cnf

在[mysqld]下添加,实现不区分表名大小写 
lower_case_table_names=1 

//如果是windows则不用关心

2：

更改编码为UTF-8
[client]
default-character-set=utf8    //中文乱码问题

[mysqld]  
character_set_server=utf8    //中文乱码问题
init_connect='SET NAMES utf8'   //中文乱码问题


[mysql] 
default-character-set=utf8   //中文乱码问题

 
3：
更改数据库引擎为InnoDB 以支持事务
[mysqld]  


default-storage-engine =InnoDB #InnoDB MYISAM    //InnoDB才支持事务
#skip-innodb                             //InnoDB才支持事务
 
4：
启动的时候需要使用   /usr/share/mysql/mysql.server   start 
默认是自动启动，如果不是  chkconfig mysql on更改为自动启动
 
5：
创建数据库的时候需要指定编码
create  database  dbname  default charset utf8

 
6: 
mysql 更改密码
mysqladmin -u root -p password root   回车后提示输入原密码(如果原密码为空，直接回车就把密码从空改成了root)

 
7:
设置mysql 允许远程连接
RENAME USER 'root'@'localhost' TO 'root'@'%';  
 
8：
备份和还原

备份：  mysqldump -h127.0.0.1 -uroot -proot dbname>dbname2012.bak.sql
还原：  source  dbname2012.bak.sql





 
 