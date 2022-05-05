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
    //check if bid satisfies bidIncrement and is higher than highest bid
    if (maxBid.getString(1) != null &&
    		Float.parseFloat(request.getParameter("amount")) < Float.parseFloat(maxBid.getString(1)) + Float.parseFloat(auction.getString(6))) {
    	out.print("Bid not high enough. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
    } else {
    	//check if bid was already placed
        ps = con.prepareStatement("SELECT * FROM Bids WHERE auctionId=? AND username=?");
        ps.setString(1, "" + aucId);
        ps.setString(2, username);
        ResultSet bids = ps.executeQuery();
        if (!bids.next()) { //insert new bid if doesn't exist
        	if (request.getParameter("autobidbutton") != null &&
        			request.getParameter("amount") != null && request.getParameter("upperLimit") != null && request.getParameter("bidIncrement") != null) { //autobid
            	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, username, auctionId, increment) VALUES (?, ?, ?, ?, ?)");
        	    bidsStmt.setString(1, request.getParameter("amount"));
        	    bidsStmt.setString(2, request.getParameter("upperLimit"));
        	    bidsStmt.setString(3, username);
        	    bidsStmt.setString(4, aucId);
        	    bidsStmt.setString(5, request.getParameter("bidIncrement"));
        	    bidsStmt.executeUpdate();
        	    out.print("AutoBid placed successfully! <a href='main.jsp'>Close.</a>");
            } else if (request.getParameter("bidbutton") != null && request.getParameter("amount") != null) { //normal bid
            	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, username, auctionId) VALUES (?, ?, ?)");
            	bidsStmt.setString(1, request.getParameter("amount"));
            	bidsStmt.setString(2, username);
            	bidsStmt.setString(3, aucId);
            	bidsStmt.executeUpdate();
            	out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
            } else {
            	out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
            }
        } else { //update bid if does exist
        	if (request.getParameter("autobidbutton") != null &&
        			request.getParameter("amount") != null && request.getParameter("upperLimit") != null && request.getParameter("bidIncrement") != null) { //autobid
        		PreparedStatement bidsStmt = con.prepareStatement("UPDATE Bids SET amount=?, upperLimit=?, increment=? WHERE auctionId=? AND username=?");
        		bidsStmt.setString(1, request.getParameter("amount"));
        	    bidsStmt.setString(2, request.getParameter("upperLimit"));
        	    bidsStmt.setString(3, request.getParameter("increment"));
        	    bidsStmt.setString(4, username);
        	    bidsStmt.setString(5, aucId);
        	    bidsStmt.executeUpdate();
        	    out.print("AutoBid placed successfully!<a href='main.jsp'>Close.</a>");
        	} else if (request.getParameter("bidbutton") != null && request.getParameter("amount") != null) { //normal bid
        		PreparedStatement bidsStmt = con.prepareStatement("UPDATE Bids SET amount=? WHERE username=? AND auctionId=?");
        		bidsStmt.setString(1, request.getParameter("amount"));
        	    bidsStmt.setString(2, username);
        	    bidsStmt.setString(3, aucId);
        	    bidsStmt.executeUpdate();
        	    out.print("Bid placed successfully! <a href='main.jsp'>Close.</a>");
        	} else {
        		out.print("Bid not entered correctly. <a href='displayAuction.jsp?Id=" + aucId + "'>Try again.</a>");
        	}
        }
    }
    
    
    //TODO: update automatic bids
    ps = con.prepareStatement("SELECT * FROM Bids WHERE auctionId=?");
    ps.setString(1, "" + aucId);
    ResultSet bids = ps.executeQuery();
    while (bids.next()) {
    	
    }
	%>
</body>
</html>