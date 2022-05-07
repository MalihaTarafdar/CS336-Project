<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

<% 
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	
	String editUser = request.getParameter("username");
	String editPass = request.getParameter("password");
	String curUserEdit = (String)session.getAttribute("usrr"); 
	
	PreparedStatement userOnly = con.prepareStatement("UPDATE Users SET username = '" + editUser + "' WHERE username = '" + curUserEdit + "'");
	PreparedStatement passOnly = con.prepareStatement("UPDATE Users SET password = '" + editPass + "' WHERE username = '" + curUserEdit + "'");
	PreparedStatement both = con.prepareStatement("UPDATE Users SET username = '" + editUser + "', password = '" + editPass + "' WHERE username = '" + curUserEdit + "'");
	
	if(editUser.equals(null)){
		userOnly.executeUpdate();
		curUserEdit = editUser;
	}else if(editPass.equals(null)){
		passOnly.executeUpdate();
	}else{
		curUserEdit = editUser;
		both.executeUpdate();
	}
	
	
	
	session.removeAttribute("usrr");
	response.sendRedirect("viewAccount.jsp"); 
%>

</body>
</html>