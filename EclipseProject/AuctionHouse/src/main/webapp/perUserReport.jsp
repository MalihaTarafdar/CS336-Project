<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Earnings Report for End-Users</title>
</head>
<body>

<% 
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
        
    DecimalFormat f = new DecimalFormat("#0.00");
    
    //buyers not sellers
    String qr = "select username, SUM(price) from (select s.username, s.auctionId, b.price from sells s LEFT JOIN buys b using(auctionId) where b.auctionId IS NOT NULL) as t1 group by username;";
    
    Statement findUsers = con.createStatement();
    ResultSet userSells = findUsers.executeQuery(qr);
    
    out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.println("Earnings By End-User");
	out.println("<TR>");
	out.println("<TH>" + "Username" + "</TH>");
	out.println("<TH>" + "Total Sales" + "</TH>");
	out.println("</TR>");
    
	while(userSells.next()){
		out.println("<TR>");
		out.println("<TH>" + userSells.getString(1) + "</TH>");
		out.println("<TH>" + "$" + f.format(userSells.getFloat(2)) + "</TH>");
		out.println("</TR>");
		
		
	}
	
	
	out.println("</TABLE></P>");
    
    
%>
<a href='admin.jsp'>Return</a>

</body>
</html>