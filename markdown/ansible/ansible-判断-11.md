1. ###### when

  ```yaml
  ---
  - hosts: A
    	remote_user: root
    	tasks:
   	- name: ls /root
     	shell: 
       	ls /root
     	register: return_result
   	- name: debug msg
     		debug:
       msg: "成功执行"
     	#when相当于if
     	when: return_result.rc == 0
  ```

2. ###### test

   ```yaml
   ---
   - hosts: A
     remote_user: root
     vars:
       dir: /root/test
     tasks:
       - name: debug msg 1
         debug: 
           msg: "YES"
         #文件存在执行
         when: dir is exists 
       - name: debug msg 2
         debug: 
           msg: "NO"
         #文件不存在执行
         when: not dir is exists  
   ```

   ```bash
   #测试test变量
   defined(已定义)
   undefined(未定义)
   null（空值）
   
   #执行结果
   success或succeeded（执行成功）
   failure或failed（执行失败）
   change或chenged（执行返回changed）
   skip或skipped（跳过的任务）
   
   #路径
   file（是否为文件）
   directory（是否为目录）
   link（是否为连接）
   mount（是否为挂载点）
   is_exists或exists（是否存在）
   
   #字符串
   lower（是否全为小写）
   upper（是否全为大写）
   
   #数字类型
   even（是否为偶数）
   odd（是否为奇数）
   divisibleby(num)（是否可以整数，如果返回0，则为真）
   
   #其他
   #比较操作符 := gt, ge, lt, le, eq, ne
   version('版本号', '比较操作符')
   version("7", 'gt')
   
   a is subset(b)(a是否为b子集)
   a is superset(b)(a是否为b超集)
   
   string（是否为字符串）
   number（是否为数字）
   ```

   

