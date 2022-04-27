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
	Welcome to AuctionHouse!
	<br/>
	Login or register:
	
	<form method="POST" action="loginRegister.jsp">
		Username: <input type="text" name="username"/><br/>
    	Password: <input type="password" name="password"/><br/>
       <input type="submit" name="login" value="Login"/>
       <input type="submit" name="register" value="Register"/>
	</form>

</body>
</html>