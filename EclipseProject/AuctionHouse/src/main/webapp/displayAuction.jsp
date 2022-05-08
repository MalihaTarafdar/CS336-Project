<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.lang.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>


<!DOCTYPE html>
<html>
<head>
	<style>
		span {
			font-size: 20px;
		}
	</style>
	<%
	Class.forName("com.mysql.jdbc.Driver");
   	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
	
   	int auctionId = Integer.parseInt(request.getParameter("Id"));
   	
   	NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
	DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd 'at' HH:mm:ss");
   	
	//get auction
   	Statement st = con.createStatement();
   	PreparedStatement ps = con.prepareStatement("SELECT * FROM auction WHERE auctionId=?");
   	ps.setInt(1, auctionId);
   	ResultSet auction = ps.executeQuery();
   	auction.next();
   	
   	int itemId = auction.getInt(2);
   	String itemName = auction.getString(3);
   	float minPrice = auction.getFloat(4);
   	float initialPrice = auction.getFloat(5);
   	float bidIncrement = auction.getFloat(6);
   	Timestamp closeDateTime = auction.getTimestamp(7);
	%>
	<meta charset="ISO-8859-1">
	<title><%=itemName%></title>
</head>
<body>
	<a href="main.jsp">Return to Main</a>
	
	<%
	//get item
	ps = con.prepareStatement("SELECT * FROM Electronics WHERE itemId=?");
	ps.setInt(1, itemId);
	ResultSet item = ps.executeQuery();
	item.next();
	
	//get max bid
	ps = con.prepareStatement("SELECT username, amount FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId = ?) AND auctionId = ?");
  	ps.setInt(1, auctionId);
  	ps.setInt(2, auctionId);
  	ResultSet maxBid = ps.executeQuery();
	boolean hasMaxBid = maxBid.next();
	String maxBidUser = hasMaxBid ? maxBid.getString(1) : "NO BIDS";
	float maxBidAmount = hasMaxBid ? maxBid.getFloat(2) : -1;
	
	
	
	
	
	//AUCTION INFO
	
	out.print("<p>");
	
	out.print("<span style='font-size:24px;'>Auction of " + itemName + "</span><br/>");
	out.print("<span style='color: #3D8A30;'>" +
			((maxBidUser != null) ?
			"Current Bid: " + currencyFormat.format(maxBidAmount) :
			"Starting Bid: " + currencyFormat.format(initialPrice)) + "</span><br/>");
	
	boolean isClosed = LocalDateTime.now().isAfter(closeDateTime.toLocalDateTime());
	
	ps = con.prepareStatement("SELECT username, amount FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId = ?) AND auctionId = ? AND amount >= ?");
	ps.setInt(1, auctionId);
	ps.setInt(2, auctionId);
	ps.setFloat(3, minPrice);
	ResultSet winner = ps.executeQuery();
	boolean hasWinner = winner.next();
	String winnerUser = hasWinner ? winner.getString(1) : "NO WINNER";
	float winnerAmount = hasWinner ? winner.getFloat(2) : -1;
	
	out.print("<span>" + ((isClosed && hasWinner) ? "Winner: " + winnerUser : "Leading Bidder: " + maxBidUser) + "</span><br/>");
	
	//check if own auction
	//PreparedStatement doesn't allow parameters inside single quotes
	Statement oaSt = con.createStatement();
	ResultSet ownAuction = oaSt.executeQuery(
			"SELECT DISTINCT a.* FROM Sells s, Auction a " +
			"WHERE s.username = '" + session.getAttribute("user") + "' AND a.auctionId = " + auctionId + " " +
			"AND s.auctionId = a.auctionId");
	boolean isOwnAuction = ownAuction.next();
	
	if (isOwnAuction) {
		out.print("<span>Minimum Price (hidden): " + ((minPrice > 0) ? currencyFormat.format(minPrice) : "NONE") + "</span><br/>");
	}
	
	out.print("<span>Minimum increment: " + currencyFormat.format(bidIncrement) + "</span><br/>");
	out.print("<span>Close" + ((isClosed) ? "d" : "s") + " on " + closeDateTime.toLocalDateTime().format(dateFormatter) + "</span><br/>");
	
	out.print("</p>");
	
	
	
	
	
	//AUCTION DETAILS
	
	out.print("<p style='font-size:18px';>");
	
	out.print("Auction ID#: " + auctionId + "<br/>");
	out.print("Item ID#: " + itemId + "<br/>");
	out.print("Serial Number: " + ((item.getInt(2) > 0) ? item.getInt(2) : "not provided") + "<br/>");
	out.print("Brand: " + ((item.getString(3) != null) ? item.getString(3) : "not provided") + "<br/>");
	out.print("Model: " + ((item.getString(4) != null) ? item.getString(4) : "not provided") + "<br/>");
	out.print("Year: " + ((item.getInt(5) > 0) ? item.getInt(5) : "not provided") + "<br/>");
	out.print("Power Supply: " + ((item.getString(6) != null) ? item.getString(6) : "not provided") + "<br/>");
	out.print("CPU: " + ((item.getString(7) != null) ? item.getString(7) : "not provided") + "<br/>");
	out.print("GPU: " + ((item.getString(8) != null) ? item.getString(8) : "not provided") + "<br/>");
	out.print("RAM: " + ((item.getString(9) != null) ? item.getString(9) : "not provided") + "<br/>");
	out.print("Screen Size: " + ((item.getFloat(10) > 0) ? item.getFloat(10) : "not provided") + "<br/>");
	out.print("Touch Screen: " + item.getBoolean(11) + "<br/>");
	out.print("Camera: " + ((item.getString(12) != null) ? item.getString(12) : "not provided") + "<br/>");
	out.print("Storage (GB): " + ((item.getInt(13) > 0) ? item.getInt(13) : "not provided") + "<br/>");
	out.print("Chip: " + ((item.getString(14) != null) ? item.getString(14) : "not provided") + "<br/>");
	
	out.print("</p>");
	
	
	
	
	
	//BUY ITEM (FOR WINNER)
	
	ResultSet buyer = st.executeQuery("SELECT username, auctionId FROM Buys WHERE username = '" + session.getAttribute("user") + "' AND auctionId = " + auctionId);
	if (buyer.next()) {
	%>
		<span style="color: blue;">You already purchased this item.</span><br/>
	<%
	} else if (hasWinner && isClosed && session.getAttribute("user").equals(winnerUser)) {
	%>
		<span>You won the auction! Purchase the item for <span style="color: blue;">$<%=winnerAmount%></span>.</span>
		<form method="POST" action="buyItem.jsp">
			<input type="hidden" name="amount" value="<%=winnerAmount%>"/>
			<input type="hidden" name="auctionId" value="<%= auctionId %>"/>
			<input type="submit" name="buybutton" value="Buy Item"/>
		</form><br/>
	<%
	}
	
	
	
	
	
	//BIDDING
	
	//cannot bid on own auction or if closed
	if (!isOwnAuction && !isClosed) {
	%>
		How to bid:
		<ul>
			<li>Auto-bid: fill out amount, upper limit, and increment</li>
			<li>Normal bid: fill out amount</li>
		</ul>
		<form method="POST" action="makeBid.jsp?Id=<%=auctionId%>">
			Amount: <input type="text" name="amount"/> <br/>
			Upper Limit: <input type="text" name="upperLimit"/> <br/>
			Increment: <input type="text" name="increment"/> <br/>
			<input type="submit" name="autoBid" value="Auto-Bid"/>
			<input type="submit" name="manualBid" value="Manual Bid"/>
		</form>
	<%
	}
	%>
	<br/>
	
	
	
	
	
	<%//BID HISTORY%>
	
	<span>Bid History</span>
	<table border=1>
		<tr>
			<th>User</th>
			<th>Amount</th>
		</tr>
		<%
		ps = con.prepareStatement("SELECT username, amount FROM Bids WHERE auctionId=? ORDER BY bidId DESC");
		ps.setInt(1, auctionId);
		ResultSet bidHistory = ps.executeQuery();
		while (bidHistory.next()) {
			String bidUser = bidHistory.getString(1);
			float bidAmount = bidHistory.getFloat(2);
			
			out.print("<tr>");
			out.print("<td>" + bidUser + "</td>");
			out.print("<td>" + currencyFormat.format(bidAmount) + "</td>");
			out.print("</tr>");
		}
		%>
	</table>
</body>
</html>