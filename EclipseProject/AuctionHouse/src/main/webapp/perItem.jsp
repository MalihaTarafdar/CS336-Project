<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Earnings Per Item</title>
</head>
<body>

<%	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
        
    DecimalFormat f = new DecimalFormat("#0.00");
    
    out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.println("Earnings Per Item Report");
	out.println("<TR>");
	out.println("<TH>" + "Item Id" + "</TH>");
	out.println("<TH>" + "Brand" + "</TH>");
	out.println("<TH>" + "Model" + "</TH>");
	out.println("<TH>" + "Sales" + "</TH>");
	out.println("</TR>");
	
	
	Statement itemDST = con.createStatement(); 
    ResultSet itemDetails = itemDST.executeQuery("select itemId, brand, model from electronics");
	
    Statement earningSt = con.createStatement();
    //ResultSet earningsPerItem = earningSt.executeQuery(" select e.itemId, SUM(b.price) from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId");
	ResultSet earningsPerItem = earningSt.executeQuery("(SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId) order by itemId;");
    
	
	while(itemDetails.next()){
		
		
		out.println("<TR>");
		out.println("<TD>" + itemDetails.getInt(1) + "</TD>");
		out.println("<TD>" + itemDetails.getString(2) + "</TD>");
		out.println("<TD>" + itemDetails.getString(3) + "</TD>");
		
		
		if (earningsPerItem.next()) {			
			out.println("<TD>" + "$" + f.format(earningsPerItem.getFloat(2)) + "</TD>");
		} else {
			out.println("<TD>$0.00</TD>");
		}
		
		out.println("</TR>");
	}
    
	
	out.println("</TABLE></P>");
	
%>

<a href='admin.jsp'>Return</a>


</body>
</html>