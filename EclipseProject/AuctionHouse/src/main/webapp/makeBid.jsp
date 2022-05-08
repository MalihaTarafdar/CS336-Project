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
    ps = con.prepareStatement("SELECT amount, username FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) AND auctionId=?");
  	ps.setString(1, "" + aucId);
  	ps.setString(2, "" + aucId);
  	ResultSet maxBid = ps.executeQuery();
  	float price = (maxBid.next() && maxBid.getString(1) != null) ? maxBid.getFloat(1) : auction.getFloat(5);
    //reject bid if (less than highest bid + bidIncrement) or (if amount is more than upper limit)
    if (amount < price + auction.getFloat(6)) {
    	out.print("Bid not high enough. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
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
			if (amount > upperLimit) {
		    	out.print("Amount cannot be higher than upper limit. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
		    }
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
    	//max bid user should not continuously bid over themselves
    //active bid = bid with max bidId for each user
    HashSet<String> usersUpdated = new HashSet<>();
    boolean done = true;
    do {
    	done = true;
	    ps = con.prepareStatement("SELECT amount, username FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) AND auctionId=?");
	  	ps.setString(1, "" + aucId);
	  	ps.setString(2, "" + aucId);
	  	maxBid = ps.executeQuery();
	  	if (!maxBid.next()) break;
	  	float maxAmount = (maxBid.getString(1) != null) ? Float.parseFloat(maxBid.getString(1)) : -1;
	  	
	  	//PreparedStatement does not allow parameters inside single quotes
	  	Statement st = con.createStatement();
	    ResultSet bids = st.executeQuery("SELECT * FROM Bids WHERE bidId IN (SELECT MAX(bidId) FROM Bids WHERE auctionId=" + aucId + " AND NOT username='" + maxBid.getString(2) + "' GROUP BY USERNAME)");
	    while (bids.next()) {
	    	float aucBidIncrement = Float.parseFloat(auction.getString(6));
	    	float bidsAmount = Float.parseFloat(bids.getString(1));
	    	float bidsUpperLimit = (bids.getString(2) != null) ? Float.parseFloat(bids.getString(2)) : -1;
	    	float bidsIncrement = (bids.getString(3) != null) ? Float.parseFloat(bids.getString(3)) : -1;
	    	
	    	if (bidsAmount < maxAmount && bidsUpperLimit != -1) {
	    		//automatically bid multiple times if does not reach (amount + aucBidIncrement)
	    		float add = maxAmount + aucBidIncrement - bidsAmount;
	    		add += (add % bidsIncrement);
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
	    		usersUpdated.add(bids.getString(4));
	    		done = false;
	    	}
	    }
    } while (!done);
    
    //send alerts to users whose bids were updated
    for (String user : usersUpdated) {
    	ps = con.prepareStatement("INSERT INTO Alerts(alertId, username, alert, dateTime) VALUES (?,?,?,?)");
    	
    	Statement st1 = con.createStatement();
    	Statement st2 = con.createStatement();
    	ResultSet rs1 = st1.executeQuery("SELECT MAX(alertId) FROM Alerts");
		ResultSet rs2 = st2.executeQuery("SELECT count(*) FROM Alerts");
		rs1.next();
		rs2.next();
		int alertId = (rs2.getInt("count(*)") > 0 ? rs1.getInt("MAX(alertId)") + 1 : 1);
		ps.setString(1, "" + alertId);
		
		ps.setString(2, user);
		ps.setString(3, "Your bid on <a href='displayAuction.jsp?Id=" + aucId + "'>Auction " + aucId + "</a> has been automatically udpated. ");
		ps.setString(4, LocalDateTime.now().toString());
		ps.executeUpdate();
    }
	%>
	
	
	
	
	
	
	
	
</body>
</html>