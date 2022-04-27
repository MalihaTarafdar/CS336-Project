<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Register | AuctionHouse</title>
</head>
<body>
	
<%
	//get credentials
    String username = request.getParameter("username");   
    String password = request.getParameter("password");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    //check if username exists
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("select * from users where username='" + username + "'");
    if (!rs.next()) { //does not exist
    	//create user
        PreparedStatement pst = con.prepareStatement("INSERT INTO Users(username, password) VALUES (?, ?)");
        pst.setString(1, username);
        pst.setString(2, password);
        pst.executeUpdate();
               
    	session.setAttribute("user", username); //the username will be stored in the session
        response.sendRedirect("main.jsp");
    } else { //exists
        out.println("Account already exists <a href='index.jsp'>try again</a>");
    }
%>

</body>
</html>