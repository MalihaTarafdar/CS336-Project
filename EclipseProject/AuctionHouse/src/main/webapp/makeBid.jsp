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
    //out.print(aucId);
    
    if( request.getParameter("amount") == null && request.getParameter("upperLimit") == null){ //autobid
    	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, upperLimit, username, auctionId, increment) VALUES (?, ?, ?, ?, ?)");
	    bidsStmt.setString(1, request.getParameter("amount"));
	    bidsStmt.setString(2, request.getParameter("upperLimit"));
	    bidsStmt.setString(3, (String)session.getAttribute("user"));
	    bidsStmt.setString(4, aucId);
	    bidsStmt.setString(5, request.getParameter("bidIncrement"));
	    bidsStmt.executeUpdate();
    }else{//normal bid
    	PreparedStatement bidsStmt = con.prepareStatement("INSERT INTO Bids(amount, username, auctionId) VALUES (?, ?, ?)");
    	bidsStmt.setString(1, request.getParameter("amount"));
    	bidsStmt.setString(2, (String)session.getAttribute("user"));
    	bidsStmt.setString(3, aucId);
    	bidsStmt.executeUpdate();
    }
    
    
    
    response.sendRedirect("main.jsp");
	%>
</body>
</html>