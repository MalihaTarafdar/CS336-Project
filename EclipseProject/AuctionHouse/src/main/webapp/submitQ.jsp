<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Submit Question</title>
</head>
<body>
	<%	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
	
	String user = (String)session.getAttribute("user");
	
	String question = request.getParameter("question");
	PreparedStatement ps = con.prepareStatement("INSERT INTO Posts(postId, username, question) VALUES (?, ?, ?)");

	Statement mpSt = con.createStatement();
	ResultSet maxPostId = mpSt.executeQuery("SELECT MAX(postId) FROM Posts");
	maxPostId.next();
	int alertId = ((maxPostId.getString(1) != null) ? maxPostId.getInt(1) + 1 : 1);
	ps.setInt(1, alertId);
	
	ps.setString(2, user);
	ps.setString(3, question);
	ps.executeUpdate();


	response.sendRedirect("userViewForum.jsp"); 
	%>
</body>
</html>