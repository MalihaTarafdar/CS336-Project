<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Best Buyers</title>
</head>
<body>

<%	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
        
    DecimalFormat f = new DecimalFormat("#0.00");
    
    out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.println("Best Buyers Report");
	out.println("<TR>");
	out.println("<TH>" + "Username" + "</TH>");
	out.println("<TH>" + "Spent" + "</TH>");
	out.println("</TR>");
	
	
	Statement buyers = con.createStatement(); 
    ResultSet buyerDetails = buyers.executeQuery("select username, sum(price) from buys group by username order by SUM(price) desc;");
	
      
	while(buyerDetails.next()){
		
		
		out.println("<TR>");
		out.println("<TD>" + buyerDetails.getString(1) + "</TD>");
		out.println("<TD>" + "$" + f.format(buyerDetails.getFloat(2)) + "</TD>");
			
			
		out.println("</TR>");
	}
    
	
	out.println("</TABLE></P>");
	
%>

<a href='admin.jsp'>Return</a>


</body>
</html>