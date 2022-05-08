<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Total Earnings</title>
</head>
<body>

<%	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
    
    Statement totalEarn = con.createStatement(); 
    ResultSet total = totalEarn.executeQuery("select SUM(price) FROM Buys");
    
    NumberFormat f = NumberFormat.getCurrencyInstance();
    
    out.print("<table border=1>");
	out.print("Total Earnings Report");
	out.print("<tr>");
	out.print("<th>Total</th>");
	out.print("</tr>");
	
	total.next();
	
	out.print("<tr>");
	out.print("<td>" + f.format(total.getFloat(1)) + "</td>");
	out.print("</tr>");
	out.print("</table>");
	
%>

<a href='admin.jsp'>Return</a>
	
</body>
</html>