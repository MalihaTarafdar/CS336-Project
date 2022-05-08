<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.HashSet" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Place Bid | AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
    
    int auctionId = Integer.parseInt(request.getParameter("Id"));
    String username = (String)session.getAttribute("user");
    float amount = (!request.getParameter("amount").isEmpty()) ? Float.parseFloat(request.getParameter("amount")) : -1;
    float upperLimit = (!request.getParameter("upperLimit").isEmpty()) ? Float.parseFloat(request.getParameter("upperLimit")) : -1;
    float increment = (!request.getParameter("increment").isEmpty()) ? Float.parseFloat(request.getParameter("increment")) : -1;
    
    //get auction
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Auction WHERE auctionId = ?");
    ps.setInt(1, auctionId);
    ResultSet auction = ps.executeQuery();
    auction.next();
    
    float initialPrice = auction.getFloat(5);
    float bidIncrement = auction.getFloat(6);
    
    //get highest bid
    ps = con.prepareStatement("SELECT amount, username, upperLimit FROM Bids " +
    		"WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId = ?) AND auctionId = ?");
  	ps.setInt(1, auctionId);
  	ps.setInt(2, auctionId);
  	ResultSet maxBid = ps.executeQuery();
  	boolean hasMaxBid = maxBid.next();
  	float maxBidAmount = hasMaxBid ? maxBid.getFloat(1) : -1;
  	String maxBidUser = hasMaxBid ? maxBid.getString(2) : null;
  	float maxBidUpperLimit = hasMaxBid ? maxBid.getFloat(3) : -1;
  	
  	float price = hasMaxBid ? maxBidAmount : initialPrice;
  	
    //reject bid if (less than highest bid + bidIncrement) or (if amount is more than upper limit)
    if (amount < price + bidIncrement) {
    	out.print("Bid not high enough. <a href='displayAuction.jsp?Id=" + auctionId + "'>Try again.</a>");
    } else {
    	Statement st = con.createStatement();
		ResultSet maxBidId = st.executeQuery("SELECT MAX(bidId) FROM Bids");
		maxBidId.next();
		int bidId = ((maxBidId.getString(1) != null) ? maxBidId.getInt(1) + 1 : 1);
		
		
		
		//AUTO-BID
		if (request.getParameter("autoBid") != null && amount > 0 && upperLimit > 0 && increment > 0) { //autobid
			if (amount > upperLimit) {
		    	out.print("Amount cannot be higher than upper limit. <a href='displayAuction.jsp?Id=" + auctionId + "'>Try again.</a>");
		    } else {
		    	PreparedStatement bidsStmt = con.prepareStatement(
		    			"INSERT INTO Bids(amount, upperLimit, username, auctionId, increment, bidId) VALUES (?, ?, ?, ?, ?, ?)");
	       	    bidsStmt.setFloat(1, amount);
	       	    bidsStmt.setFloat(2, upperLimit);
	       	    bidsStmt.setString(3, username);
	       	    bidsStmt.setInt(4, auctionId);
	       	    bidsStmt.setFloat(5, increment);
	    		bidsStmt.setInt(6, bidId);
	       	    bidsStmt.executeUpdate();
	       	    out.print("AutoBid placed successfully! <a href='main.jsp'>Close.</a>");
		    }
		
		
		
		//MANUAL BID
		} else if (request.getParameter("manualBid") != null && amount > 0) {
        	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, username, auctionId, bidId) VALUES (?, ?, ?, ?)");
        	bidsStmt.setString(1, "" + amount);
        	bidsStmt.setString(2, username);
        	bidsStmt.setInt(3, auctionId);
    		bidsStmt.setString(4, "" + bidId);
        	bidsStmt.executeUpdate();
        	out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
		} else {
        	out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + auctionId + "'>Try again.</a>");
        }
	}
    
    
    
    
    
    //AUTOMATIC BIDS
    
    //find max then automatically update all other active bids, repeat until no more updates
    	//max bid user should not continuously bid over themselves
    //active bid = bid with max bidId for each user
    HashSet<String> usersUpdated = new HashSet<>();
    boolean done = true;
    do {
    	done = true;
	    ps = con.prepareStatement("SELECT amount, username FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId = ?) AND auctionId = ?");
	  	ps.setInt(1, auctionId);
	  	ps.setInt(2, auctionId);
	  	maxBid = ps.executeQuery();
	  	if (!maxBid.next()) break;
	  	float maxAmount = (maxBid.getString(1) != null) ? Float.parseFloat(maxBid.getString(1)) : -1;
	  	
	  	//PreparedStatement does not allow parameters inside single quotes
	  	Statement bSt = con.createStatement();
	    ResultSet bids = bSt.executeQuery(
	    		"SELECT * FROM Bids WHERE bidId IN (SELECT MAX(bidId) FROM Bids " + 
	    		"WHERE auctionId=" + auctionId + " AND NOT username='" + maxBid.getString(2) + "' GROUP BY USERNAME)");
	    while (bids.next()) {
	    	float bidsAmount = bids.getFloat(1);
	    	float bidsUpperLimit = bids.getFloat(2);
	    	float bidsIncrement = bids.getFloat(3);
	    	String bidsUser = bids.getString(4);
	    	
	    	if (bidsAmount < maxAmount && bidsUpperLimit > 0) {
	    		//automatically bid multiple times if does not reach (amount + aucBidIncrement)
	    		float add = maxAmount + bidIncrement - bidsAmount;
	    		add += (add % bidsIncrement);
	    		if (bidsAmount + add > bidsUpperLimit) continue;
	    		
	    		PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, increment, username, auctionId, bidId) VALUES (?, ?, ?, ?, ?, ?)");
	    		bidsStmt.setFloat(1, bidsAmount + add);
	    		bidsStmt.setFloat(2, bidsUpperLimit);
	    		bidsStmt.setFloat(3, bidsIncrement);
	    		bidsStmt.setString(4, bidsUser);
	    		bidsStmt.setInt(5, auctionId);
	    		
	    		Statement st = con.createStatement();
	    		ResultSet maxBidId = st.executeQuery("SELECT MAX(bidId) FROM Bids");
	    		maxBidId.next();
	    		int bidId = ((maxBidId.getString(1) != null) ? maxBidId.getInt(1) + 1 : 1);
	    		bidsStmt.setInt(6, bidId);
	    		
	    		bidsStmt.executeUpdate();
	    		usersUpdated.add(bidsUser);
	    		done = false;
	    	}
	    }
    } while (!done);
    

    
    
    
    //ALERTS

    //alert previous max bidder (manual bid) that a higher bid has been placed
    if (maxBidUpperLimit <= 0 && !maxBidUser.equals(username)) {
		ps = con.prepareStatement("INSERT INTO Alerts(alertId, username, alert, dateTime) VALUES (?,?,?,?)");
    	
		Statement maSt = con.createStatement();
    	ResultSet maxAlertId = maSt.executeQuery("SELECT MAX(alertId) FROM Alerts");
		maxAlertId.next();
		int alertId = ((maxAlertId.getString(1) != null) ? maxAlertId.getInt(1) + 1 : 1);
		ps.setInt(1, alertId);
		
		ps.setString(2, maxBid.getString(2));
		ps.setString(3, "A higher bid than yours has been placed on <a href='displayAuction.jsp?Id=" + auctionId + "'>Auction " + auctionId + "</a>.");
		ps.setString(4, LocalDateTime.now().toString());
		ps.executeUpdate();
    }
    
    
    //send alerts to users whose bids were updated
    for (String user : usersUpdated) {
    	ps = con.prepareStatement("INSERT INTO Alerts(alertId, username, alert, dateTime) VALUES (?,?,?,?)");
    	
    	Statement maSt = con.createStatement();
    	ResultSet maxAlertId = maSt.executeQuery("SELECT MAX(alertId) FROM Alerts");
		maxAlertId.next();
		int alertId = ((maxAlertId.getString(1) != null) ? maxAlertId.getInt(1) + 1 : 1);
		ps.setInt(1, alertId);
		
		ps.setString(2, user);
		ps.setString(3, "Your bid on <a href='displayAuction.jsp?Id=" + auctionId + "'>Auction " + auctionId + "</a> has been automatically udpated.");
		ps.setString(4, LocalDateTime.now().toString());
		ps.executeUpdate();
    }
    
    
    //alert automatic bidders that someone has bid higher than their upper limit
    Statement st = con.createStatement();
    ResultSet autoBidders = st.executeQuery(
	    		"SELECT username FROM Bids WHERE bidId IN (SELECT MAX(bidId) FROM Bids " +
	    		"WHERE auctionId = " + auctionId + " AND NOT username = '" + maxBid.getString(2) + "' AND upperLimit IS NOT NULL GROUP BY USERNAME)");
    while (autoBidders.next()) {
		ps = con.prepareStatement("INSERT INTO Alerts(alertId, username, alert, dateTime) VALUES (?,?,?,?)");
    	
		Statement maSt = con.createStatement();
    	ResultSet maxAlertId = maSt.executeQuery("SELECT MAX(alertId) FROM Alerts");
		maxAlertId.next();
		int alertId = ((maxAlertId.getString(1) != null) ? maxAlertId.getInt(1) + 1 : 1);
		ps.setInt(1, alertId);
		
		ps.setString(2, autoBidders.getString(1));
		ps.setString(3, "Someone has bid higher than your upper limit on <a href='displayAuction.jsp?Id=" + auctionId + "'>Auction " + auctionId + "</a>.");
		ps.setString(4, LocalDateTime.now().toString());
		ps.executeUpdate();
    }
	%>	
</body>
</html>