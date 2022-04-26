<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>AuctionHouse</title>
</head>
<body>
	
<%
    String username = request.getParameter("username");   
    String password = request.getParameter("password");
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    Statement st = con.createStatement();
    ResultSet rs;
    rs = st.executeQuery("select * from users where username='" + username + "' and password='" + password + "'");
    if (rs.next()) {
        session.setAttribute("user", username); // the username will be stored in the session
        out.println("welcome " + username);
        out.println("<a href='logout.jsp'>Log out</a>");
        response.sendRedirect("main.jsp");
    } else {
        out.println("Invalid password <a href='index.jsp'>try again</a>");
    }
%>

</body>
</html>