<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	
<% 	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	int editId = Integer.parseInt(request.getParameter("bidId"));
	
	
	String req = "DELETE FROM Bids WHERE bidId = '" + editId + "'";
	
	PreparedStatement pst = con.prepareStatement(req);
	pst.executeUpdate();
	
	response.sendRedirect("editAccount.jsp");
%>


</body>
</html>