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
		
    	//show itemName as title
    	Statement st = con.createStatement();
    	PreparedStatement ps = con.prepareStatement("SELECT itemName FROM auction WHERE auctionId=?");
    	String aucId = request.getParameter("Id");
    	ps.setString(1, "" + request.getParameter("Id"));
    	ResultSet itemName = ps.executeQuery();
    	itemName.next();
    	String name = itemName.getString(1);
	
	%>
	<meta charset="ISO-8859-1">
	<title><% out.print(itemName.getString(1));%></title>
</head>
<body>
	
	<%
	ps = con.prepareStatement("SELECT * FROM auction WHERE auctionId=?");
	ps.setString(1, aucId);
	ResultSet auction = ps.executeQuery();
	auction.next();
	String itemId = auction.getString(2);
	Statement getStuff = con.createStatement();
	ResultSet item_rs1 = getStuff.executeQuery("SELECT * FROM Electronics WHERE itemId=" + itemId);
	item_rs1.next();
	
	ps = con.prepareStatement("SELECT amount, username FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) AND auctionId=?");
  	ps.setString(1, "" + aucId);
  	ps.setString(2, "" + aucId);
  	ResultSet maxBid = ps.executeQuery();
  	maxBid.next();
	String curBid = maxBid.getString(1);
	float currentBid;
	boolean nobids = true;
	String leader;
	if(curBid == null){
	  	currentBid = Float.parseFloat(auction.getString(5));
	  	nobids = true;
	  	leader = "NO CURRENT BIDS";
	}else{
		currentBid = Float.parseFloat(curBid);
		leader = maxBid.getString(2);
		nobids = false;
	}
	
	float incValue = Float.parseFloat(auction.getString(6));
	
  	DecimalFormat f = new DecimalFormat("#0.00");
	DateTimeFormatter dateForm = DateTimeFormatter.ofPattern("yyyy-dd-MM HH:mm:ss");
	
	
	String d1 = auction.getString(7);
	String t1[] = d1.split(" ");	
	String why = t1[1];
	StringBuffer sbf = new StringBuffer(why); //listen I know this looks insane, but like string split or substring wouldnt recognize the .0 in the raw string
	sbf.deleteCharAt(8);					//its insane, this was the only way to remove the last 2 digits, im losing my mind -JM
	sbf.deleteCharAt(8);
	String closeTime = sbf.toString();

	String finalDateTime = t1[0] + " " + closeTime;
	LocalDateTime closeDate = LocalDateTime.parse(finalDateTime, dateForm);// 5/4: returns as date, will need later for closing stuff and comparisons(or not) 
	
	float minPrice = Float.parseFloat(auction.getString(4));
			
	//check if auction is user's auction
	//PreparedStatement does not allow parameters inside single quotes
	Statement stmt = con.createStatement();
	ResultSet ownAuction = stmt.executeQuery("SELECT DISTINCT a.* FROM Sells s, Auction a WHERE s.username = '" 
		+ session.getAttribute("user") + "' AND s.auctionId = a.auctionId AND a.auctionId=" + aucId);
	boolean isOwnAuction = ownAuction.next();
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
		
	<span style="font-size:20px"><% out.println("Leading Bidder: " + leader); %></span><br/>
	<%
	if (isOwnAuction) {%>
		<span style="font-size:20px"><% out.println("Minimum Price (hidden): $" + f.format(minPrice)); %></span><br/>
	<%}
	%>
	<span style="font-size:20px"><% out.println("Minimum Increment: $" + f.format(incValue)); %></span><br/>
	<span style="font-size:20px"><% out.println("Closes on " + t1[0] + " at " + closeTime); %></span><br/>
	</p>
	
	<P style="font-size:18px"><%
	out.println("Auction ID#: " + aucId); %> <br/> <%
	out.println("ITEM ID#: " + itemId); %> <br/> <%
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
	
	<%
	//cannot bid on own auction
	if (!isOwnAuction) {
	%>
		How to bid:
		<ul>
			<li>Auto-bid: fill out amount, upper limit, and increment</li>
			<li>Normal bid: fill out amount</li>
		</ul>
		<form method="POST" action=<%= "\"makeBid.jsp?Id=" + aucId + "\""%>>
			Amount: <input type="text" name="amount"/> <br/>
			Upper Limit: <input type="text" name="upperLimit"/> <br/>
			Increment: <input type="text" name="bidIncrement"/> <br/>
			<input type="submit" name="autobidbutton" value="AutoBid?"/>
			<input type="submit" name="bidbutton" value="Place Bid?"/>
		</form>
	<%
	}
	%>
	<br>
	
	
	Bid History
	<table>
		
	</table>

</body>
</html>