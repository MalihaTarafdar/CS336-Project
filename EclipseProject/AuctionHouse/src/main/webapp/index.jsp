<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Login | AuctionHouse</title>
</head>
<body>
	Login
	
	<form method="POST" action="login.jsp">
		Username: <input type="text" name="username"/> <br/>
      	Password: <input type="password" name="password"/> <br/>
       <input type="submit" value="Login"/>
	</form>
</body>
</html>