<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Create New Auction | AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
    
    //insert into Auction, Item, Electronics, Sells
    PreparedStatement pst = con.prepareStatement(
    		"INSERT INTO Auction(auctionId, itemName, minPrice, initialPrice, bidIncrement, closeDateTime) VALUES (?, ?, ?, ?, ?, ?)");
	
    Statement st = con.createStatement();
    ResultSet rs1 = st.executeQuery("SELECT max(auctionId) FROM Auction");
    ResultSet rs2 = st.executeQuery("SELECT count(*) FROM Auction");
    rs2.next();
    pst.setString(1, "" + (rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1));
    //out.print(rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1);
    
    pst.setString(2, request.getParameter("itemName"));
    
	pst.setString(3, request.getParameter("minPrice"));
	pst.setString(4, request.getParameter("initialPrice"));
	pst.setString(5, request.getParameter("bidIncrement"));
	pst.setString(6, request.getParameter("closeDateTime"));
	pst.executeUpdate();
	
	response.sendRedirect("main.jsp");
	%>
</body>
</html>