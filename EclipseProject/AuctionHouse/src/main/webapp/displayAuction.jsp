<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.lang.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>


<!DOCTYPE html>
<html>
<head>
	<%
		Class.forName("com.mysql.jdbc.Driver");
    	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
		
    	Statement st = con.createStatement();
    	PreparedStatement ps = con.prepareStatement("SELECT itemName FROM auction WHERE auctionId=?");
    	String aucId = request.getParameter("Id");
    	ps.setString(1, "" + request.getParameter("Id"));
    	ResultSet itemName = ps.executeQuery();
    	itemName.next();
    	String name = itemName.getString(1);
    	//itemName.getString(1);
	
	%>
	<meta charset="ISO-8859-1">
	<title><% out.print(itemName.getString(1));%></title>
</head>
<body>
	
	<%
	ps = con.prepareStatement("SELECT itemId FROM auction WHERE auctionId=?");
	ps.setString(1, aucId);
	ResultSet itemRs = ps.executeQuery();
	itemRs.next();
	String itemID = itemRs.getString(1);
	ps = con.prepareStatement("SELECT itemId FROM auction WHERE auctionId=");
	Statement getStuff = con.createStatement();
	ResultSet item_rs1 = getStuff.executeQuery("SELECT * FROM Electronics WHERE itemId=" + itemID);
	item_rs1.next();
	
	ps = con.prepareStatement("Select MAX(b.amount) FROM Bids b, Auction a WHERE b.auctionId =?");
  	ps.setString(1, "" + aucId);
  	ResultSet maxBid = ps.executeQuery();
  	maxBid.next();
	String curBid = maxBid.getString(1);
	float currentBid;
	boolean nobids = true;
	if(curBid == null){
		ps = con.prepareStatement("select initialPrice FROM auction WHERE auctionId=?");
		ps.setString(1, "" + aucId);
		ResultSet initBid = ps.executeQuery();
	  	initBid.next();
	  	currentBid = Float.parseFloat(initBid.getString(1));
	  	nobids = true;
	}else{
		currentBid = Float.parseFloat(curBid);
		nobids = false;
	}
	
	ps = con.prepareStatement("select bidIncrement FROM auction WHERE auctionId=?"); //its now hitting me all these new prepare statements are very redundant
	ps.setString(1, "" + aucId);
	ResultSet  increment = ps.executeQuery();
	increment.next();
  	float incValue = Float.parseFloat(increment.getString(1));
	
  	DecimalFormat f = new DecimalFormat("#0.00");
	DateTimeFormatter dateForm = DateTimeFormatter.ofPattern("yyyy-dd-MM HH:mm:ss");
	
	
	ps = con.prepareStatement("select closeDateTime FROM auction WHERE auctionId=?"); //its now hitting me all these new prepare statements are very redundant
	ps.setString(1, "" + aucId);
	ResultSet  closeDT = ps.executeQuery();
	closeDT.next();
	String d1 = closeDT.getString(1);
	String t1[] = d1.split(" ");	
	String why = t1[1];
	StringBuffer sbf = new StringBuffer(why); //listen I know this looks insane, but like string split or substring wouldnt recognize the .0 in the raw string
	sbf.deleteCharAt(8);					//its insane, this was the only way to remove the last 2 digits, im losing my mind -JM
	sbf.deleteCharAt(8);
	String closeTime = sbf.toString();

	String finalDateTime = t1[0] + " " + closeTime;
	LocalDateTime closeDate = LocalDateTime.parse(finalDateTime, dateForm);// 5/4: returns as date, will need later for closing stuff and comparisons(or not) 
	
	
	
	
	
	%> 
	<p>
	<span style="font-size:24px"><% out.println("Auction of " + name); %></span><br/>
	
	<% 
	if(nobids){ %>
		  <span style="font-size:20px; color: #3D8A30"><% out.println("Starting Bid: $" + f.format(currentBid)); %></span> <br/> <%
	}else{
		%><span style="font-size:20px; color: #3D8A30"><% out.println("Current Bid: $" + f.format(currentBid)); %></span> <br/> <%
	}
	%>
		
	
	<span style="font-size:20px"><% out.println("Minimum Increment: $" + f.format(incValue)); %></span><br/>
	<span style="font-size:20px"><% out.println("Closes on " + t1[0] + " at " + closeTime); %></span><br/>
	</p>
	
	<P style="font-size:18px"><%
	out.println("Auction ID#: " + aucId); %> <br/> <%
	out.println("ITEM ID#: " + itemID); %> <br/> <%
	if(item_rs1.getString(2) != null){
		out.println("Serial Number: " + item_rs1.getString(2));
		%> <br/> <%
	}
	
	if(item_rs1.getString(3) != null){
		out.println("Brand: " + item_rs1.getString(3));
		%> <br/> <%
	}
	
	if(item_rs1.getString(4) != null){
		out.println("Model: " + item_rs1.getString(4));
		%> <br/> <%
	}
	
	if(item_rs1.getString(5) != null){
		out.println("Year: " + item_rs1.getString(5));
		%> <br/> <%
	}
	
	if(item_rs1.getString(6) != null){
		out.println("Power Supply: " + item_rs1.getString(6));
		%> <br/> <%
	}
	
	if(item_rs1.getString(7) != null){
		out.println("CPU: " + item_rs1.getString(7));
		%> <br/> <%
	}
	
	if(item_rs1.getString(8) != null){
		out.println("GPU: " + item_rs1.getString(8));
		%> <br/> <%
	}
	
	if(item_rs1.getString(9) != null){
		out.println("RAM: " + item_rs1.getString(9));
		%> <br/> <%
	}
	
	if(item_rs1.getString(10) != null){
		out.println("Screen Size: " + item_rs1.getString(10));
		%> <br/> <%
	}
	//NEED TO REVIST WHEN A ACTUAL PHONE AUCTION IS IN AUCTION DATABASE
	if(item_rs1.getString(11) != null){
		out.println("Touch Screen: " + item_rs1.getString(11));
		%> <br/> <%
	}
	
	if(item_rs1.getString(12) != null){
		out.println("Camera: " + item_rs1.getString(12));
		%> <br/> <%
	}
	
	if(item_rs1.getString(13) != null){
		out.println("Storage(GBs): " + item_rs1.getString(13));
		%> <br/> <%
	}
	
	if(item_rs1.getString(14) != null){
		out.println("Chip: " + item_rs1.getString(14));
		%> <br/> <%
	}
	
	%></P>
	
	Set up automatic bidding:
	<form method="POST" action=<%= "\"makeBid.jsp?Id=" + aucId + "\""%>>
		Amount: <input type="text" name="amount"/> <br/>
		Upper Limit: <input type="text" name="upperLimit"/> <br/>
		Increment: <input type="text" name="bidIncrement"/> <br/>
		<input type="submit" name="autobidbutton" value="AutoBid?"/>
		<input type="submit" name="bidbutton" value="Place Bid?"/>
	</form>




</body>
</html>