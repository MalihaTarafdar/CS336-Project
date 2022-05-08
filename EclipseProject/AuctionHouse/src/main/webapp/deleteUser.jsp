<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Delete Account | AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    String user = request.getParameter("user");
    
	PreparedStatement pst = con.prepareStatement("DELETE FROM Users WHERE username=?");
	pst.setString(1, user);
	pst.executeUpdate();
	
	if (user.equals(session.getAttribute("user"))) {		
		session.invalidate();
		response.sendRedirect("index.jsp");
	} else {
		out.println("User account deleted successfully.");
		out.print("<a href='editAccount.jsp?usr=" + user + "'>Return</a>");
	}
	%>
</body>
</html>