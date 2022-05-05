<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Login/Register | AuctionHouse</title>
</head>
<body>
	
	<%
	//get credentials
    String username = request.getParameter("username");   
    String password = request.getParameter("password");
    
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    Statement st = con.createStatement();
    
    //login
    if (request.getParameter("login") != null) {
    	//check if credentials are correct
        ResultSet rs = st.executeQuery("select * from users where username='" + username + "' and password='" + password + "'");
        if (rs.next()) { //valid
            session.setAttribute("user", username); //the username will be stored in the session
            Statement st2 = con.createStatement();
        	ResultSet saleRep = st2.executeQuery("select employeeId from users where username='" + username + "' and password='" + password + "'");
        	saleRep.next();
            if(username.equals("admin")){
            	response.sendRedirect("admin.jsp");
            }else if(saleRep.getString(1) != null){
            	response.sendRedirect("saleRep.jsp");
        	}else{
            	response.sendRedirect("main.jsp");
            }
            
        } else { //invalid
            out.println("Invalid username or password. <a href='index.jsp'>Try again</a>");
        }
    
    //register
    } else if (request.getParameter("register") != null) {
    	//check if username exists
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
            out.println("Account already exists. <a href='index.jsp'>Try again</a>");
        }
    //error
    } else {
    	throw new IllegalArgumentException("not login nor register");
    }
    
    
	%>

</body>
</html>