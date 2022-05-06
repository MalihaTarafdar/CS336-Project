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
	
	String getPostNum = "Select MAX(postId) from Posts";
	String curUser = (String)session.getAttribute("user");
	
	String qText = request.getParameter("questionText");
	PreparedStatement pst = con.prepareStatement("INSERT INTO Posts(postId, username, question) VALUES (?, ?, ?)");
	int QID = 0;
	
	Statement idSt = con.createStatement();
	ResultSet getQId = idSt.executeQuery(getPostNum);
	getQId.next();
	
	if(getQId.getInt(1) == 0){
		QID = 1;
	}else{
		QID = getQId.getInt(1) + 1;
	}
	
	pst.setInt(1, QID);
	pst.setString(2, curUser);
	pst.setString(3, qText);
	pst.executeUpdate();


	 
	response.sendRedirect("userViewForum.jsp"); 
%>
</body>
</html>