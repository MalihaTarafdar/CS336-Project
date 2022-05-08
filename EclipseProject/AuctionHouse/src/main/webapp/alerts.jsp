<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Place Bid | AuctionHouse</title>
	<style>
		span {
			font-size: 18px;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<a href="main.jsp">Return to Main</a><br>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd 'at' HH:mm:ss");
    
    Statement st = con.createStatement();
	ResultSet alerts = st.executeQuery("SELECT * FROM Alerts WHERE username='" + session.getAttribute("user") + "' ORDER BY dateTime DESC");
    
	out.print("<span>Alerts</span><br>");
    
    if (alerts.next()) {
    	String alert = alerts.getString(3);
    	Timestamp dateTime = alerts.getTimestamp(4);
    	
    	out.print("<table border=1>");
    	
    	out.print("<tr>");
    	out.print("<th>Date & Time</th>");
    	out.print("<th>Message</th>");
    	out.print("</tr>");
    	
        do {
        	alert = alerts.getString(3);
        	dateTime = alerts.getTimestamp(4);
        	
        	out.print("<tr>");
        	out.print("<td>" + dateTime.toLocalDateTime().format(dateFormatter) + "</td>");
        	out.print("<td>" + alert + "</td>");
        	out.print("</tr>");
        } while (alerts.next());
        
	    out.print("</table>");
    } else {
    	out.print("No new alerts.<br>");
    }
    %>
</body>
</html>