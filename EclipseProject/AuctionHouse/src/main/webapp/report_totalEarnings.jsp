<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Total Earnings</title>
</head>
<body>

<%	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    Statement totalEarn = con.createStatement(); 
    ResultSet total = totalEarn.executeQuery("select SUM(price) FROM Buys");
    
    DecimalFormat f = new DecimalFormat("#0.00");
    
    out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.println("Total Earnings Report");
	out.println("<TR>");
	out.println("<TH>" + "Total" + "</TH>");
	out.println("</TR>");
	total.next();
	out.println("<TR>");
	if(total.getString(1) != null){
		out.println("<TD>" + "$" + f.format(Float.parseFloat(total.getString(1))) + "</TD>");
	}else{
		
		out.println("<TD>" + "$0.00" + "</TD>");
	}
	
	out.println("</TR>");
	out.println("</TABLE></P>");
	
%>

<a href='admin.jsp'>Return</a>
	
</body>
</html>