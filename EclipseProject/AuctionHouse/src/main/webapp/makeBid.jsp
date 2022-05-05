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
    	//check if bid was already placed
        ps = con.prepareStatement("SELECT * FROM Bids WHERE auctionId=? AND username=?");
        ps.setString(1, "" + aucId);
        ps.setString(2, username);
        ResultSet bids = ps.executeQuery();
        if (!bids.next()) { //insert new bid if doesn't exist
        	if (request.getParameter("autobidbutton") != null && amount != -1 && upperLimit != -1 && bidIncrement != -1) { //autobid
            	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, username, auctionId, increment) VALUES (?, ?, ?, ?, ?)");
        	    bidsStmt.setString(1, "" + amount);
        	    bidsStmt.setString(2, "" + upperLimit);
        	    bidsStmt.setString(3, username);
        	    bidsStmt.setString(4, aucId);
        	    bidsStmt.setString(5, "" + bidIncrement);
        	    bidsStmt.executeUpdate();
        	    out.print("AutoBid placed successfully! <a href='main.jsp'>Close.</a>");
            } else if (request.getParameter("bidbutton") != null && amount != -1) { //normal bid
            	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, username, auctionId) VALUES (?, ?, ?)");
            	bidsStmt.setString(1, "" + amount);
            	bidsStmt.setString(2, username);
            	bidsStmt.setString(3, aucId);
            	bidsStmt.executeUpdate();
            	out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
            } else {
            	out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
            }
        } else { //update bid if does exist
        	if (request.getParameter("autobidbutton") != null && amount != -1 && upperLimit != -1 && bidIncrement != -1) { //autobid
        		PreparedStatement bidsStmt = con.prepareStatement("UPDATE Bids SET amount=?, upperLimit=?, increment=? WHERE username=? AND auctionId=?");
        		bidsStmt.setString(1, "" + amount);
        	    bidsStmt.setString(2, "" + upperLimit);
        	    bidsStmt.setString(3, "" + bidIncrement);
        	    bidsStmt.setString(4, username);
        	    bidsStmt.setString(5, aucId);
        	    bidsStmt.executeUpdate();
        	    out.print("AutoBid placed successfully!<a href='main.jsp'>Close.</a>");
        	} else if (request.getParameter("bidbutton") != null && amount != -1) { //normal bid
        		PreparedStatement bidsStmt = con.prepareStatement("UPDATE Bids SET amount=? WHERE username=? AND auctionId=?");
        		bidsStmt.setString(1, "" + amount);
        	    bidsStmt.setString(2, username);
        	    bidsStmt.setString(3, aucId);
        	    bidsStmt.executeUpdate();
        	    out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
        	} else {
        		out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
        	}
        }
    }
    
    
    //update automatic bids
    //find max then automatically update all other bids, repeat until no more updates
    boolean done = true;
    do {
    	done = true;
	    ps = con.prepareStatement("Select MAX(b.amount), b.username FROM Bids b WHERE b.auctionId =?");
	  	ps.setString(1, "" + aucId);
	  	maxBid = ps.executeQuery();
	  	maxBid.next();
	  	
	    ps = con.prepareStatement("SELECT * FROM Bids WHERE auctionId=? AND NOT username=?");
	    ps.setString(1, "" + aucId);
	    ps.setString(2, maxBid.getString(2));
	    ResultSet bids = ps.executeQuery();
	    while (bids.next()) {
	    	float aucBidIncrement = Float.parseFloat(auction.getString(6));
	    	float bidsAmount = Float.parseFloat(bids.getString(1));
	    	float bidsBidIncrement = Float.parseFloat(bids.getString(3));
	    	
	    	if (amount != -1 && Float.parseFloat(bids.getString(1)) < amount && bids.getString(2) != null) {
	    		PreparedStatement updateBidStmt = con.prepareStatement("UPDATE Bids SET amount=? WHERE auctionId=? AND username=?");
	    		//automatically bid multiple times if does not reach (amount + aucBidIncrement)
	    		float add = amount + aucBidIncrement - bidsAmount;
	    		add = (float)(Math.ceil((double)add / (double)bidsBidIncrement) * bidsBidIncrement);
	    		updateBidStmt.setString(1, "" + (bidsAmount + add));
	    		updateBidStmt.setString(2, "" + aucId);
	    		updateBidStmt.setString(3, bids.getString(4));
	    		updateBidStmt.executeUpdate();
	    		done = false;
	    	}
	    }
    } while (!done);
	%>
	
	
	
	
	
</body>
</html>