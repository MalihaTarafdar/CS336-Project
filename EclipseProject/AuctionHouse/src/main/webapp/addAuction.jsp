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
	
	<form action="makeAuction.jsp">
	<%
	out.print("Item Name: <input type=\"text\" name=\"itemName\" required/> <br/>");
	out.print("Serial Number: <input type=\"text\" name=\"serialNum\"/> <br/>");
	out.print("Brand: <input type=\"text\" name=\"brand\"/> <br/>");
	out.print("Model: <input type=\"text\" name=\"model\"/> <br/>");
	out.print("Year: <input type=\"text\" name=\"year\"/> <br/>");
	if (type.equals("PC")){ // sn, brand, model, year, wireless, power supply
		out.print("CPU: <input type=\"text\" name=\"cpu\"/> <br/>");
		out.print("GPU: <input type=\"text\" name=\"gpu\"/> <br/>");
		out.print("RAM: <input type=\"text\" name=\"ram\"/> <br/>");
	} else if (type.equals("Laptop/Tablet")){
		out.print("CPU: <input type=\"text\" name=\"cpu\"/> <br/>");
		out.print("GPU: <input type=\"text\" name=\"gpu\"/> <br/>");
		out.print("RAM: <input type=\"text\" name=\"ram\"/> <br/>");
		out.print("Screen Size(Inches): <input type=\"text\" name=\"size\"/> <br/>");
		out.print("Touchscreen(y/n): <input type=\"checkbox\" name=\"touch\"/> <br/>");
	} else {
		out.print("Screen Size(Inches): <input type=\"text\" name=\"size\"/> <br/>");
		out.print("Camera: <input type=\"text\" name=\"camera\"/> <br/>");
		out.print("Storage(GBs): <input type=\"text\" name=\"storage\"/> <br/>");
		out.print("Chip: <input type=\"text\" name=\"chip\"/> <br/>");
	}
	out.print("Minimum Price (hidden): <input type=\"text\" name=\"minPrice\" required/> <br/>");
	out.print("Initial Price: <input type=\"text\" name=\"initialPrice\" required/> <br/>");
	out.print("Bid Increment: <input type=\"text\" name=\"bidIncrement\" required/> <br/>");
	out.print("Close Date and Time: <input style=\"width:200px;\" type=\"text\" name=\"closeDateTime\" placeholder=\"YYYY-MM-DD hh:mm:ss\" required/> <br/>");
	
	%>
		<input type="submit" value="Submit"/>
	</form>
	
	
	
	
	
	
	
</body>
</html>