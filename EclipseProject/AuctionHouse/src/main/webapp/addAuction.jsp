<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Create New Auction | AuctionHouse</title>
</head>
<body>
	<%
	String type = request.getParameter("electronic");
	%>
	<a href="main.jsp">Return</a><br/><br/>
	
	<form action="makeAuction.jsp">
		<input type="hidden" name="type" value="<%=type%>"/>
		Item Name: <input type="text" name="itemName" required/><br/>
		Serial Number: <input type="text" name="serialNum"/><br/>
		Brand: <input type="text" name="brand"/><br/>
		Model: <input type="text" name="model"/><br/>
		Year: <input type="text" name="year"/><br/>
	<%if (type.equals("PC")){ // sn, brand, model, year, wireless, power supply%>
		CPU: <input type="text" name="cpu"/><br/>
		GPU: <input type="text" name="gpu"/><br/>
		RAM: <input type="text" name="ram"/><br/>
	<%} else if (type.equals("Laptop/Tablet")) {%>
		CPU: <input type="text" name="cpu"/><br/>
		GPU: <input type="text" name="gpu"/><br/>
		RAM: <input type="text" name="ram"/><br/>
		Screen Size(Inches): <input type="text" name="size"/><br/>
		Touchscreen(y/n): <input type="checkbox" name="touch"/><br/>
	<%} else {%>
		Screen Size(Inches): <input type="text" name="size"/><br/>
		Camera: <input type="text" name="camera"/><br/>
		Storage(GBs): <input type="text" name="storage"/><br/>
		Chip: <input type="text" name="chip"/><br/>
	<%}%>
	Minimum Price (hidden): <input type="text" name="minPrice"/><br/>
	Initial Price: <input type="text" name="initialPrice" required/><br/>
	Bid Increment: <input type="text" name="bidIncrement" required/><br/>
	Close Date and Time: <input style="width:200px;" type="text" name="closeDateTime" placeholder="YYYY-MM-DD hh:mm:ss" required/><br/>
		<input type="submit" value="Submit"/>
	</form>
	
</body>
</html>