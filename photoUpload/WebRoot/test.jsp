<%@ page language="java" import="java.util.*" contentType="text/html;charset=utf-8" pageEncoding="utf-8"%>
<html>
  <body>
    <form action="UpLoad" enctype="multipart/form-data" method="post">
     用户名<input type="text" name="name" /><br />
    密码 <input type="text" name="password" /><br />
     
     城市<input type="text" name="city" /><br />
   省  <input type="text" name="prov" /><br />
   国家  <input type="text" name="county" /><br />
  文件1   <input type="file" name="myfile" /><br/>
 文件2    <input type="file" name="myfile" /><br/>
     <input type="submit" />
    </form>
    <br/><br/><br/><br/> 
</body></html>