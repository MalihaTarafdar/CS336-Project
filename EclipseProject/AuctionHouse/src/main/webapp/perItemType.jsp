<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Earnings Per Item Type</title>
</head>
<body>
<% 
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
        
    DecimalFormat f = new DecimalFormat("#0.00");
    
    //total for all items in order
    //SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId) order by itemId;
    
    //all PC itemId
    //Statement getPC = con.createStatement(); 
    //ResultSet PCs = getPC.executeQuery("select itemId from electronics where screenSize IS NULL AND touchScreen IS NULL AND camera IS NULL AND storage IS NULL AND chip IS NULL");
    String pcItems = "select itemId from electronics where screenSize IS NULL AND touchScreen IS NULL AND camera IS NULL AND storage IS NULL AND chip IS NULL";
    		
    //all laptop/table itemId
    //Statement getLP = con.createStatement(); 
    //ResultSet laptop_tablets = getLP.executeQuery("select itemId from electronics where screenSize IS NOT NULL AND touchScreen IS NOT NULL AND camera IS NULL AND storage IS NULL AND chip IS NULL");
    String lptItems = "select itemId from electronics where screenSize IS NOT NULL AND touchScreen IS NOT NULL AND camera IS NULL AND storage IS NULL AND chip IS NULL";
    
    //all phone itemId
    //Statement getSt = con.createStatement(); 
    //ResultSet electronics = getSt.executeQuery("select itemId from electronics where cpu IS NULL AND gpu IS NULL AND ram IS NULL");
    String phoneItems = "select itemId from electronics where cpu IS NULL AND gpu IS NULL AND ram IS NULL";
    
    //table of itemId and their SUM(prices)
    //Statement earningSt = con.createStatement(); 
    //ResultSet earningsPerItem = earningSt.executeQuery("select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId;");
    String earnPerItem = "select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId;";
    
    //gets price based on itemId
    PreparedStatement pst = con.prepareStatement("select price from ((SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId)) as t1 where itemId=?;");
    //return count of item based on query used
    PreparedStatement countSt = con.prepareStatement("select count(*) from (?) as t1");
    //get total price depending on type
    PreparedStatement totalOfType = con.prepareStatement("select SUM(price) FROM ((SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId)) as t1 WHERE itemId IN (?);");
    
    
    
    
    
    out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.println("Earnings By Item Type");
	out.println("<TR>");
	out.println("<TH>" + "Item Type" + "</TH>");
	out.println("<TH>" + "Number Sold" + "</TH>");
	out.println("<TH>" + "Total Sales" + "</TH>");
	out.println("</TR>");
	
	
	ResultSet countTotal, priceTotal;
	out.println("<TR>");
	out.println("<TD>" + "PC" + "</TD>");
	countSt = con.prepareStatement("select count(*) from (" + pcItems + ") as t1");
  	countTotal = countSt.executeQuery();
  	countTotal.next();
  	out.println("<TD>" + countTotal.getInt(1) + "</TD>");
  	
  	totalOfType = con.prepareStatement("select SUM(price) FROM ((SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId)) as t1 WHERE itemId IN (" + pcItems + ");");

  	priceTotal = totalOfType.executeQuery();
  	priceTotal.next();
  	out.println("<TD>" + "$" + f.format(priceTotal.getFloat(1)) + "</TD>");
  	out.println("</TR>");
  	
  	out.println("<TR>");
	out.println("<TD>" + "Laptop/Tablet" + "</TD>");
	countSt = con.prepareStatement("select count(*) from (" + lptItems + ") as t1");
  	countTotal = countSt.executeQuery();
  	countTotal.next();
  	out.println("<TD>" + countTotal.getInt(1) + "</TD>");
  	
  	totalOfType = con.prepareStatement("select SUM(price) FROM ((SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId)) as t1 WHERE itemId IN (" + lptItems + ");");

  	priceTotal = totalOfType.executeQuery();
  	priceTotal.next();
  	out.println("<TD>" + "$" + f.format(priceTotal.getFloat(1)) + "</TD>");
  	out.println("</TR>");
  	
  	out.println("<TR>");
	out.println("<TD>" + "Phones" + "</TD>");
	countSt = con.prepareStatement("select count(*) from (" + phoneItems + ") as t1");
  	countTotal = countSt.executeQuery();
  	countTotal.next();
  	out.println("<TD>" + countTotal.getInt(1) + "</TD>");
  	
  	totalOfType = con.prepareStatement("select SUM(price) FROM ((SELECT itemId, b.price FROM auction a LEFT JOIN buys b using(auctionId) where b.auctionId IS NULL) UNION (select e.itemId, SUM(b.price)  from buys b, auction a, electronics e WHERE e.itemid = a.itemid AND a.auctionId = b.auctionId group by e.itemId)) as t1 WHERE itemId IN (" + phoneItems + ");");

  	priceTotal = totalOfType.executeQuery();
  	priceTotal.next();
  	out.println("<TD>" + "$" + f.format(priceTotal.getFloat(1)) + "</TD>");
  	out.println("</TR>");
  	
  	
  	out.println("</TABLE></P>");
    
  	



%>
<a href='admin.jsp'>Return</a>
</body>
</html>