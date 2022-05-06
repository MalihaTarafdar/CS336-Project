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
	<a href="main.jsp">Return to Main</a><br>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    Statement st = con.createStatement();
	ResultSet alerts = st.executeQuery("SELECT * FROM Alerts WHERE username='" + session.getAttribute("user") + "'");
    out.print("<span style='font-size: 18px;'>Alerts</span><br>");
    if (alerts.next()) {
    	out.print("<table border=1>");
        do {
        	out.print("<tr><td>");
        	out.print(alerts.getString(3));
        	out.print("</td></tr>");
        } while (alerts.next());
	    out.print("</table>");
    } else {
    	out.print("No new alerts.<br>");
    }
    %>
</body>
</html>