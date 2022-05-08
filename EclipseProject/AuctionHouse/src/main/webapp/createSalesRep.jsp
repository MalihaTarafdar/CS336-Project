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

	String username = request.getParameter("username");   
	String password = request.getParameter("password");
	
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    Statement st = con.createStatement();
    ResultSet maxEID = st.executeQuery("select MAX(employeeId) FROM Users");
   	maxEID.next();
    
   	int eid = (maxEID.getInt(1) != 0) ? eid = maxEID.getInt(1) + 1 : 1;
    
  	//check if username exists
    ResultSet rs = st.executeQuery("select * from users where username='" + username + "'");
    if (!rs.next()) { //does not exist
    	//create user
        PreparedStatement pst = con.prepareStatement("INSERT INTO Users(username, password, employeeId) VALUES (?, ?, ?)");
	    pst.setString(1, username);
	    pst.setString(2, password);
	    pst.setInt(3, eid);
	    pst.executeUpdate();
               
    	session.setAttribute("user", username); //the username will be stored in the session
        response.sendRedirect("admin.jsp");
    } else { //exists
        out.println("Account already exists. <a href='admin.jsp'>Try again</a>");
    }
%>

	

</body>
</html>