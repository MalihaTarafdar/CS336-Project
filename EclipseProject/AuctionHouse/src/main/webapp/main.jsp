<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>AuctionHouse</title>
</head>
<body>
	Login successful!
	<%
    if ((session.getAttribute("user") == null)) {
	%>
	You are not logged in<br/>
	<a href="index">Please Login</a>
	<%} else {
	%>
	Welcome <%=session.getAttribute("user")%>
	<a href='deleteUser.jsp'>Delete User</a>
	<a href='logout.jsp'>Log out</a>
	<%
	    }
	%>
	
</body>
</html>