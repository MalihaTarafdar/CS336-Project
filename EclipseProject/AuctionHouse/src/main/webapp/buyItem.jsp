<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Place Bid | AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    String aucId = request.getParameter("auctionId");
    
    PreparedStatement ps = con.prepareStatement("INSERT INTO Buys(username, auctionId, price) VALUES (?,?,?)");
    ps.setString(1, (String)session.getAttribute("user"));
    ps.setString(2, "" + aucId);
    ps.setString(3, request.getParameter("amount"));
    ps.executeUpdate();
	%>
	Item purchased successfully! <a href='displayAuction.jsp?Id=<%= aucId %>'>Close.</a>
</body>
</html>