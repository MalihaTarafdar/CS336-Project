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
	<meta charset="ISO-8859-1">
	<title>AuctionHouse</title>
	<style>
		td {
			text-align: center;
		}
		span {
			font-size: 18px;
			font-weight: bold;
		}
	</style>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
    
    PreparedStatement ps;
	NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
	DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd 'at' HH:mm:ss");
	%>
</head>
<body>
	<%
	if (session.getAttribute("user") == null) {
	%>
		You are not logged in.
		<br/>
		<a href="index.jsp">Please Login</a>
	<%
	} else {
	%>
		<span><a href='main.jsp'>AuctionHouse</a></span><br/>
		<span>Welcome <%=session.getAttribute("user")%>!</span>
		<br/><br/>
		
		Create an auction:<br/>
		<label for="electronic">Choose type of electronic:</label>
		<form method="POST" action="addAuction.jsp">
			<select name="electronic" id="type">
			  <option value="PC">PC</option>
			  <option value="Laptop/Tablet">Laptop/Tablet</option>
			  <option value="Phone">Phone</option>
			</select>
			<input type="submit" value="Add Auction"/>
		</form><br/>
		
		<span style='font-size: 18px;'>Post and View Questions</span><br/>
		<a href='userViewForum.jsp'>Enter Forum</a><p></p>

	<%
	//CHECK FOR NEW WINS
    
    //out of auctions that the user has bid on, check if win
    //send alert if not already sent
    
    //get auctions that user has bid on
    Statement aboSt = con.createStatement();
    ResultSet auctionsBidOn = aboSt.executeQuery(
    		"SELECT a.auctionId, a.minPrice, a.closeDateTime FROM Bids b, Auction a " +
    		"WHERE bidId IN (SELECT MAX(bidId) FROM Bids WHERE username = '" + session.getAttribute("user") + "' GROUP BY username, auctionId) " +
    		"AND b.auctionId = a.auctionId");
    
    while (auctionsBidOn.next()) {
    	int auctionId = auctionsBidOn.getInt(1);
        float minPrice = auctionsBidOn.getFloat(2);
        Timestamp closeDateTime = auctionsBidOn.getTimestamp(3);
    	
    	//check if user is winner
    	ps = con.prepareStatement(
    			"SELECT username, amount FROM Bids " +
    			"WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) " +
    			"AND auctionId = ? AND amount >= ? AND username = '" + session.getAttribute("user") + "'");
    	ps.setInt(1, auctionId);
    	ps.setInt(2, auctionId);
    	ps.setFloat(3, minPrice);
    	ResultSet winner = ps.executeQuery();
    	
    	//check if auction is closed
    	boolean isClosed = LocalDateTime.now().isAfter(closeDateTime.toLocalDateTime());
    	
    	//check if alert has already been sent
    	String message = "You won <a href=''displayAuction.jsp?Id=" + auctionId + "''>Auction " + auctionId + "</a>!";
    	Statement alertSt = con.createStatement();
    	ResultSet winnerAlert = alertSt.executeQuery("SELECT * FROM Alerts WHERE username='" + session.getAttribute("user") + "' AND alert='" + message + "'");
    	
    	//send alert
    	if (winner.next() && isClosed && !winnerAlert.next()) {
    		ps = con.prepareStatement("INSERT INTO Alerts(alertId, username, alert, dateTime) VALUES (?,?,?,?)");
        	
        	Statement maSt = con.createStatement();
        	ResultSet maxAlertId = maSt.executeQuery("SELECT MAX(alertId) FROM Alerts");
    		maxAlertId.next();
    		int alertId = ((maxAlertId.getString(1) != null) ? maxAlertId.getInt(1) + 1 : 1);
    		ps.setInt(1, alertId);
    		
    		ps.setString(2, (String)session.getAttribute("user"));
    		ps.setString(3, "You won <a href='displayAuction.jsp?Id=" + auctionId + "'>Auction " + auctionId + "</a>!");
    		ps.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
    		ps.executeUpdate();
    	}
    }
    
    
    
    
    
    //ALERTS
    
    //show alerts within the past week
    Statement raSt = con.createStatement();
	ResultSet recentAlerts = raSt.executeQuery(
			"SELECT * FROM Alerts WHERE username = '" + session.getAttribute("user") + "' " +
			"AND dateTime BETWEEN date_sub(now(), INTERVAL 1 WEEK) and now() ORDER BY dateTime DESC");
	
    out.print("<span>Recent Alerts</span> (within the last week)");
    
    if (recentAlerts.next()) {
    	String alert = recentAlerts.getString(3);
    	Timestamp dateTime = recentAlerts.getTimestamp(4);
    	
    	out.print("<table border=1>");
    	
    	out.print("<tr>");
    	out.print("<th>Date & Time</th>");
    	out.print("<th>Message</th>");
    	out.print("</tr>");
    	
        do {
        	alert = recentAlerts.getString(3);
        	dateTime = recentAlerts.getTimestamp(4);
        	
        	out.print("<tr>");
        	out.print("<td>" + dateTime.toLocalDateTime().format(dateFormatter) + "</td>");
        	out.print("<td>" + alert + "</td>");
        	out.print("</tr>");
        } while (recentAlerts.next());
        
	    out.print("</table>");
    } else {
    	out.print("No new alerts.<br/>");
    }
	out.print("<a href='alerts.jsp'>Show all alerts</a>");
	
	
	
	
	
	//YOUR AUCTIONS
	
	//get auctions created by user
	Statement yaSt = con.createStatement();
	ResultSet yourAuctions = yaSt.executeQuery(
			"SELECT DISTINCT a.* FROM Sells s, Auction a WHERE s.username = '" + session.getAttribute("user") + "' " +
			"AND a.auctionId = s.auctionId");
	
	out.print("<p><table border=1>");
	out.print("<span>Your Auctions</span><br/>");
	
	out.print("<tr>");
	out.print("<th>Auction ID#</th>");
	out.print("<th>Item ID#</th>");
	out.print("<th>Item Name</th>");
	out.print("<th>Minimum Price</th>");
	out.print("<th>Initial Price</th>");
	out.print("<th>Bid Increment</th>");
	out.print("<th>Closing Date & Time</th>");
	out.print("<th>Status</th>");
	out.print("<th>Highest Bid</th>");
	out.print("</tr>");
	
	while (yourAuctions.next()) {
		int auctionId = yourAuctions.getInt(1);
		int itemId = yourAuctions.getInt(2);
		String itemName = yourAuctions.getString(3);
		float minPrice = yourAuctions.getFloat(4);
		float initialPrice = yourAuctions.getFloat(5);
		float bidIncrement = yourAuctions.getFloat(6);
		Timestamp closeDateTime = yourAuctions.getTimestamp(7);
		
		out.print("<tr>");
		out.print("<td><a href='displayAuction.jsp?Id=" + auctionId + "'>" + auctionId + "</a></td>");
		out.print("<td>" + itemId + "</td>");
		out.print("<td>" + itemName + "</td>");
		out.print("<td>" + ((minPrice > 0) ? currencyFormat.format(minPrice) : "NONE") + "</td>");
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
	
	
	
	
	
	//ALL ACTIVE AUCTIONS
	
	//search and sort
	Statement aSt = con.createStatement();
	
	String select = "SELECT * FROM Auction";
	String orderBy = (request.getParameter("order") != null) ?
			"ORDER BY " + request.getParameter("sort") + " " + request.getParameter("order") : "";
	
	String query = select + " " + orderBy;
	ResultSet auctions = aSt.executeQuery(query);
	
	out.print("<p><table border=1>");
	out.print("<span>All Active Auctions</span><br/>");
	%>
	
	<form method="GET" action="main.jsp">
		Search & Sort Options<br/>
		Search term: 
		<select name="searchTermBy">
			<option value="name">Item Name</option>
			<option value="details">Item Details</option>
		</select>
		: <input type="text" name="searchTerm" placeholder="search term"/><br/>
		Id: 
		<select name="searchIdBy">
			<option value="auctionId">Auction ID</option>
			<option value="itemId">Item ID</option>
		</select>
		: <input type="text" name="searchId" placeholder="ID#"/><br/>
		Price range: <input type="text" name="priceFrom" placeholder="from"/> - <input type="text" name="priceTo" placeholder="to"/><br/>
		Date range: <input type="text" name="dateStart" placeholder="start"/> - <input type="text" name="dateEnd" placeholder="end"/><br/>
		Sort by 
		<select name="sort">
			<option value="auctionId">Auction ID</option>
			<option value="itemId">Item ID</option>
			<option value="itemName">Item Name</option>
			<option value="initialPrice">Initial Price</option>
			<option value="closeDateTime">Closing Date & Time</option>
		</select> : 
		<select name="order">
			<option value="ASC">Ascending</option>
			<option value="DESC">Descending</option>
		</select><br/>
		<input type="submit" value="Submit"/>
	</form><br/>
	
	<%
	out.print("<tr>");
	out.print("<th>Auction ID#</th>");
	out.print("<th>Item ID#</th>");
	out.print("<th>Item Name</th>");
	out.print("<th>Closing Date & Time</th>");
	out.print("<th>Status</th>");
	out.print("<th>Highest Bid</th>");
	out.print("</tr>");
	
	while (auctions.next()) {
		int auctionId = auctions.getInt(1);
		int itemId = auctions.getInt(2);
		String itemName = auctions.getString(3);
		Timestamp closeDateTime = auctions.getTimestamp(7);
		
		out.print("<td><a href='displayAuction.jsp?Id=" + auctionId + "'>" + auctionId + "</a></td>");
		out.print("<td>" + itemId + "</td>");
		out.print("<td>" + itemName + "</td>");
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
	
	
	
	
	
	//YOUR ACTIVE BIDS
	
	Statement ybSt = con.createStatement();
	ResultSet yourBids = ybSt.executeQuery(
			"SELECT a.auctionId, a.itemName, b.amount, a.closeDateTime, b.upperLimit, b.increment " +
			"FROM Bids b, Auction a " +
			"WHERE b.auctionId = a.auctionId AND bidId IN (SELECT MAX(bidId) FROM Bids WHERE username='" + session.getAttribute("user") + "' GROUP BY username, auctionId)");
	
	out.print("<p><table border=1>");
	out.print("<span>Your Active Bids</span><br/>");
	
	out.print("<tr>");
	out.print("<th>Auction ID#</th>");
	out.print("<th>Item Name</th>");
	out.print("<th>Your Bid</th>");
	out.print("<th>Highest Bid</th>");
	out.print("<th>Leading User</th>");
	out.print("<th>Closing Date & Time</th>");
	out.print("<th>Status</th>");
	out.print("<th>Auto-Bid</th>");
	out.print("<th>Upper Limit</th>");
	out.print("<th>Increment</th>");
	out.print("</tr>");
	
	while (yourBids.next()) {
		int auctionId = yourBids.getInt(1);
		String itemName = yourBids.getString(2);
		float amount = yourBids.getFloat(3);
		Timestamp closeDateTime = yourBids.getTimestamp(4);
		float upperLimit = yourBids.getFloat(5);
		float increment = yourBids.getFloat(6);
		
		out.print("<tr>");
		out.print("<td><a href='displayAuction.jsp?Id=" + auctionId + "'>" + auctionId + "</a></td>");
		out.print("<td>" + itemName + "</td>");
		out.print("<td>" + amount + "</td>");
		
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
		
		boolean autoBid = upperLimit > 0;
		out.print("<td>" + (autoBid ? "ENABLED" : "DISABLED") + "</td>");
		out.print("<td>" + (autoBid ? currencyFormat.format(upperLimit) : "N/A") + "</td>");
		out.print("<td>" + (autoBid ? currencyFormat.format(increment) : "N/A") + "</td>");
		out.print("</tr>");
	}
	out.print("</table></p>");
	%>
	
	<form method="POST">
		<input type="hidden" name="user" value="<%=session.getAttribute("user")%>"/>
		<input type="submit" name="delete" formaction="deleteUser.jsp" value="Delete Account"/>
		<input type="submit" name="logout" formaction="logout.jsp" value="Log Out"/>
	</form>
	<%
	}
	%>
	
</body>
</html>