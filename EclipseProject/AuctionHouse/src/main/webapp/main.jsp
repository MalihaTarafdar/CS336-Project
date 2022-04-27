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
	<%
    if (session.getAttribute("user") == null) {
	%>
		You are not logged in<br/>
		<a href="index.jsp">Please Login</a>
	<%} else {
	%>
		Welcome <%=session.getAttribute("user")%><br>
		
		<label for="electronic">Choose type of electronic:</label>
		<form method="POST" action="addAuction.jsp">
			<select name="electronic" id="type">
			  <option value="PC">PC</option>
			  <option value="Laptop/Tablet">Laptop/Tablet</option>
			  <option value="Phone">Phone</option>
			</select>
			<input type="submit" value="Add Auction"/>
		</form>
		
		<a href='deleteUser.jsp'>Delete Account</a>
		<a href='logout.jsp'>Log out</a>
	<%
	}
	%>
	
</body>
</html>