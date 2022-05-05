<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Place Bid | AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    String aucId = request.getParameter("Id");
    String username = (String)session.getAttribute("user");
    float amount = (!request.getParameter("amount").isEmpty()) ? Float.parseFloat(request.getParameter("amount")) : -1;
    float upperLimit = (!request.getParameter("upperLimit").isEmpty()) ? Float.parseFloat(request.getParameter("upperLimit")) : -1;
    float bidIncrement = (!request.getParameter("bidIncrement").isEmpty()) ? Float.parseFloat(request.getParameter("bidIncrement")) : -1;
    
    //get auction
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Auction WHERE auctionId=?");
    ps.setString(1, aucId);
    ResultSet auction = ps.executeQuery();
    auction.next();
    //get highest bid
    ps = con.prepareStatement("Select MAX(b.amount), b.username FROM Bids b, Auction a WHERE b.auctionId =?");
  	ps.setString(1, "" + aucId);
  	ResultSet maxBid = ps.executeQuery();
  	maxBid.next();
  	float price = (maxBid.getString(1) != null) ? Float.parseFloat(maxBid.getString(1)) : Float.parseFloat(auction.getString(5));
    //reject bid if (less than highest bid + bidIncrement) or (if amount is more than upper limit)
    if (amount < price + Float.parseFloat(auction.getString(6))) {
    	out.print("Bid not high enough. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
    } else if (amount > upperLimit) {
    	out.print("Amount cannot be higher than upper limit. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
    } else {
		
    	Statement st1 = con.createStatement();
		Statement st2 = con.createStatement();
		ResultSet rs1 = st1.executeQuery("SELECT MAX(bidId) FROM Bids");
		ResultSet rs2 = st2.executeQuery("SELECT count(*) FROM Bids");
		rs1.next();
		rs2.next();
		int bidId = (rs2.getInt("count(*)") > 0 ? rs1.getInt("MAX(bidId)") + 1 : 1);
    	
		ps = con.prepareStatement("SELECT * FROM Bids WHERE auctionId=? AND username=?");
		ps.setString(1, "" + aucId);
		ps.setString(2, username);
		ResultSet bids = ps.executeQuery();
		if (request.getParameter("autobidbutton") != null && amount != -1 && upperLimit != -1 && bidIncrement != -1) { //autobid
           	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, username, auctionId, increment, bidId) VALUES (?, ?, ?, ?, ?, ?)");
       	    bidsStmt.setString(1, "" + amount);
       	    bidsStmt.setString(2, "" + upperLimit);
       	    bidsStmt.setString(3, username);
       	    bidsStmt.setString(4, aucId);
       	    bidsStmt.setString(5, "" + bidIncrement);
    		bidsStmt.setString(6, "" + bidId);
       	    bidsStmt.executeUpdate();
       	    out.print("AutoBid placed successfully! <a href='main.jsp'>Close.</a>");
		} else if (request.getParameter("bidbutton") != null && amount != -1) { //normal bid
        	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, username, auctionId, bidId) VALUES (?, ?, ?, ?)");
        	bidsStmt.setString(1, "" + amount);
        	bidsStmt.setString(2, username);
        	bidsStmt.setString(3, aucId);
    		bidsStmt.setString(4, "" + bidId);
        	bidsStmt.executeUpdate();
        	out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
		} else {
        	out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
        }
	}
    
    
    //update automatic bids
    //find max then automatically update all other active bids, repeat until no more updates
    //active bid = bid with max bidId for each user
    boolean done = true;
    do {
    	done = true;
	    ps = con.prepareStatement("Select MAX(amount), username FROM Bids WHERE auctionId=?");
	  	ps.setString(1, "" + aucId);
	  	maxBid = ps.executeQuery();
	  	maxBid.next();
	  	float maxAmount = (maxBid.getString(1) != null) ? Float.parseFloat(maxBid.getString(1)) : -1;
	  	
	    ps = con.prepareStatement(
	    		"SELECT amount, upperLimit, increment, username, auctionId, MAX(bidId) FROM Bids WHERE auctionId=? AND NOT username='" + maxBid.getString(2) + "' GROUP BY username");
	    ps.setString(1, "" + aucId);
	    ResultSet bids = ps.executeQuery();
	    while (bids.next()) {
	    	float aucBidIncrement = Float.parseFloat(auction.getString(6));
	    	float bidsAmount = Float.parseFloat(bids.getString(1));
	    	float bidsUpperLimit = (bids.getString(2) != null) ? Float.parseFloat(bids.getString(2)) : -1;
	    	float bidsIncrement = (bids.getString(3) != null) ? Float.parseFloat(bids.getString(3)) : -1;
	    	
	    	if (bidsAmount < maxAmount && bidsUpperLimit != -1) {
	    		//automatically bid multiple times if does not reach (amount + aucBidIncrement)
	    		float add = maxAmount + aucBidIncrement - bidsAmount;
	    		add += (add % bidsIncrement);
	    		System.out.println(bidsAmount + add > bidsUpperLimit);
	    		if (bidsAmount + add > bidsUpperLimit) continue;
	    		PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, increment, username, auctionId, bidId) VALUES (?, ?, ?, ?, ?, ?)");
	    		bidsStmt.setString(1, "" + (bidsAmount + add));
	    		bidsStmt.setString(2, "" + bidsUpperLimit);
	    		bidsStmt.setString(3, "" + bidsIncrement);
	    		bidsStmt.setString(4, bids.getString(4));
	    		bidsStmt.setString(5, "" + aucId);
	    		
	    		Statement st1 = con.createStatement();
	    		Statement st2 = con.createStatement();
	    		ResultSet rs1 = st1.executeQuery("SELECT MAX(bidId) FROM Bids");
	    		ResultSet rs2 = st2.executeQuery("SELECT count(*) FROM Bids");
	    		rs1.next();
	    		rs2.next();
	    		int bidId = (rs2.getInt("count(*)") > 0 ? rs1.getInt("MAX(bidId)") + 1 : 1);
	    		bidsStmt.setString(6, "" + bidId);
	    		
	    		bidsStmt.executeUpdate();
	    		done = false;
	    	}
	    }
    } while (!done);
	%>
	
	
	
	
	
</body>
</html>