<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
	<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
	
	String user = request.getParameter("user");
	
	PreparedStatement ps;
	NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
	DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd 'at' HH:mm:ss");
	%>
	<meta charset="ISO-8859-1">
	<title>View Account | <%=user%></title>
	<style>
		td {
			text-align: center;
		}
	</style>
</head>
<body>
	<%
	//check if account exists
	Statement st = con.createStatement();
	ResultSet exists = st.executeQuery("SELECT * FROM Users WHERE username = '" + user + "'");
	if (!exists.next()) {
		out.print("Account does not exist. <a href='main.jsp'>Try again</a>.");
	} else {
		out.print("<a href='main.jsp'>Return to Main</a><br/>");
		out.print("<span style='font-size:24px'>" + user + "'s Account</span><br/>");
		
		//USER AUCTIONS
		
		Statement uaSt = con.createStatement();
		ResultSet auctions = uaSt.executeQuery(
				"SELECT DISTINCT a.* FROM Sells s, Auction a WHERE s.username = '" + user + "' " +
				"AND a.auctionId = s.auctionId");
		
		out.print("<p><table border=1>");
		out.print("<span>" + user + "'s Auctions as a Seller</span><br/>");
		
		out.print("<tr>");
		out.print("<th>Auction ID#</th>");
		out.print("<th>Item ID#</th>");
		out.print("<th>Item Name</th>");
		out.print("<th>Initial Price</th>");
		out.print("<th>Bid Increment</th>");
		out.print("<th>Closing Date & Time</th>");
		out.print("<th>Status</th>");
		out.print("<th>Highest Bid</th>");
		out.print("</tr>");
		
		while (auctions.next()) {
			int auctionId = auctions.getInt(1);
			int itemId = auctions.getInt(2);
			String itemName = auctions.getString(3);
			float minPrice = auctions.getFloat(4);
			float initialPrice = auctions.getFloat(5);
			float bidIncrement = auctions.getFloat(6);
			Timestamp closeDateTime = auctions.getTimestamp(7);
			
			out.print("<tr>");
			out.print("<td><a href='displayAuction.jsp?Id=" + auctionId + "'>" + auctionId + "</a></td>");
			out.print("<td>" + itemId + "</td>");
			out.print("<td>" + itemName + "</td>");
			out.print("<td>" + currencyFormat.format(initialPrice) + "</td>");
			out.print("<td>" + currencyFormat.format(bidIncrement) + "</td>");
			out.print("<td>" + closeDateTime.toLocalDateTime().format(dateFormatter) + "</td>");
			
			boolean isClosed = LocalDateTime.now().isAfter(closeDateTime.toLocalDateTime());
			out.print("<td>" + (isClosed ? "CLOSED" : "OPEN") + "</td>");
			
			ps = con.prepareStatement("SELECT MAX(amount) FROM Bids WHERE auctionId=?");
		  	ps.setInt(1, auctionId);
		  	ResultSet maxBid = ps.executeQuery();
		  	maxBid.next();
		  	float maxBidAmount = maxBid.getFloat(1);
		  	out.print("<td>" + ((maxBidAmount > 0) ? currencyFormat.format(maxBidAmount) : "NONE") + "</td>");
		  
		  	out.print("</tr>");
		}
		out.print("</table></p>");
		
		
		
		
		
		//USER ACTIVE BIDS
		
		Statement ubSt = con.createStatement();
		ResultSet bids = ubSt.executeQuery(
				"SELECT a.auctionId, a.itemName, b.amount, a.closeDateTime, b.upperLimit, b.increment " +
				"FROM Bids b, Auction a " +
				"WHERE b.auctionId = a.auctionId AND bidId IN (SELECT MAX(bidId) FROM Bids WHERE username='" + user + "' GROUP BY username, auctionId)");
		
		out.print("<p><table border=1>");
		out.print("<span>" + user + "'s Auctions as a Buyer</span><br/>");
		
		out.print("<tr>");
		out.print("<th>Auction ID#</th>");
		out.print("<th>Item Name</th>");
		out.print("<th>Bid</th>");
		out.print("<th>Highest Bid</th>");
		out.print("<th>Leading User</th>");
		out.print("<th>Closing Date & Time</th>");
		out.print("<th>Status</th>");
		out.print("</tr>");
		
		while (bids.next()) {
			int auctionId = bids.getInt(1);
			String itemName = bids.getString(2);
			float amount = bids.getFloat(3);
			Timestamp closeDateTime = bids.getTimestamp(4);
			float upperLimit = bids.getFloat(5);
			float increment = bids.getFloat(6);
			
			out.print("<tr>");
			out.print("<td><a href='displayAuction.jsp?Id=" + auctionId + "'>" + auctionId + "</a></td>");
			out.print("<td>" + itemName + "</td>");
			out.print("<td>" + currencyFormat.format(amount) + "</td>");
			
			ps = con.prepareStatement("SELECT username, amount FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) AND auctionId=?");
		  	ps.setInt(1, auctionId);
		  	ps.setInt(2, auctionId);
		  	ResultSet maxBid = ps.executeQuery();
		  	maxBid.next();
		  	String maxBidUser = maxBid.getString(1);
		  	float maxBidAmount = maxBid.getFloat(2);
		  	out.print("<td>" + currencyFormat.format(maxBidAmount) + "</td>");
		  	out.print("<td>" + maxBidUser + "</td>");
		  	
			out.print("<td>" + closeDateTime.toLocalDateTime().format(dateFormatter) + "</td>");
			
			boolean isClosed = LocalDateTime.now().isAfter(closeDateTime.toLocalDateTime());
			out.print("<td>" + (isClosed ? "CLOSED" : "OPEN") + "</td>");
			
			out.print("</tr>");
		}
		out.print("</table></p>");
	}
	%>
</body>
</html>