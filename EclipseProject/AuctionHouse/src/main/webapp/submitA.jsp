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
	
	String curUser = (String)session.getAttribute("user");
	int qNum = (int)session.getAttribute("postId");
	
	String qText = request.getParameter("answerText");
	String updateStr = "UPDATE Posts SET employee ='" + curUser + "', answer = '" + qText +  "' WHERE postId = '" + qNum + "'";
	
	PreparedStatement pst = con.prepareStatement(updateStr);
	
	//Statement answSt = con.createStatement();
	//answSt.executeQuery(updateStr);
	pst.executeUpdate();
	
	session.removeAttribute("postId");
	response.sendRedirect("saleRep.jsp"); 
%>
</body>
</html>