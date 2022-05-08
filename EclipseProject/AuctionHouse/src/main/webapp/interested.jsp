<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Set Interested</title>
</head>
<body>
	<%	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
	
	String user = (String)session.getAttribute("user");
	String itemId = request.getParameter("itemId");
	String auctionId = request.getParameter("auctionId");
	
	//check if user has already set an alert
	PreparedStatement ps = con.prepareStatement("SELECT * FROM Interested WHERE username = '" + user + "' AND itemId = " + itemId);
	ResultSet exists = ps.executeQuery();
	
	if (exists.next()) {
		out.print("You have already opted to be notified.");
	} else {
		//insert into table
		ps = con.prepareStatement("INSERT INTO Interested(username, itemId) VALUES (?, ?)");
		ps.setString(1, user);
		ps.setString(2, itemId);
		ps.executeUpdate();
		out.print("Success! You will be notified when this item becomes available.");
	}
	%>

	<br/>
	<a href='displayAuction.jsp?Id=<%=auctionId%>'>Return</a>
</body>
</html>