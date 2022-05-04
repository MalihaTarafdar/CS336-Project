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
    		"INSERT INTO Auction(auctionId, itemName, minPrice, initialPrice, bidIncrement, closeDateTime, itemId) VALUES (?, ?, ?, ?, ?, ?, ?)");
    
    //insert into electronics, any paramaters that dont exist are null
    PreparedStatement item_statement = con.prepareStatement(
    		"INSERT INTO Electronics(itemId, serialNumber, brand, model, year, cpu, gpu, ram, screenSize, touchScreen, camera, storage, chip) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
	
    //insert into sells
    PreparedStatement sell_statement = con.prepareStatement(
    		"INSERT INTO Sells(username, auctionId) VALUES (?, ?)");
    //get Username
    String userName = (String)session.getAttribute("user");
    
    Statement getItemID = con.createStatement();
	ResultSet item_rs1 = getItemID.executeQuery("SELECT max(itemId) FROM Electronics");
    ResultSet item_rs2 = getItemID.executeQuery("SELECT count(*) FROM Electronics");
    item_rs2.next();
    int itemID = (item_rs2.getInt("count(*)") > 0 ? item_rs1.getInt("itemId") + 1 : 1); //save itemID for electronics query
    
    
    item_statement.setString(1, "" + itemID);
    item_statement.setString(2, request.getParameter("serialNum"));
    item_statement.setString(3, request.getParameter("brand"));
    item_statement.setString(4, request.getParameter("model"));
    item_statement.setString(5, request.getParameter("year"));
    item_statement.setString(6, request.getParameter("cpu"));
    item_statement.setString(7, request.getParameter("gpu"));
    item_statement.setString(8, request.getParameter("ram"));
    item_statement.setString(9, request.getParameter("size"));
    item_statement.setString(10, request.getParameter("touch"));
    item_statement.setString(11, request.getParameter("camera"));
    item_statement.setString(12, request.getParameter("storage"));
    item_statement.setString(13, request.getParameter("chip"));
   	item_statement.executeUpdate();
   	     
    Statement st = con.createStatement();
    ResultSet rs1 = st.executeQuery("SELECT max(auctionId) FROM Auction");
    ResultSet rs2 = st.executeQuery("SELECT count(*) FROM Auction");
    rs2.next();
    int auctionID = (rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1); //need for Sells
    //pst.setString(1, "" + (rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1));
    pst.setString(1, "" + auctionID);
    //out.print(rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1);
    
    pst.setString(2, request.getParameter("itemName"));
    
	pst.setString(3, request.getParameter("minPrice"));
	pst.setString(4, request.getParameter("initialPrice"));
	pst.setString(5, request.getParameter("bidIncrement"));
	pst.setString(6, request.getParameter("closeDateTime"));
	
    //System.out.println(itemID);
    //pst.setString(7, "" + (item_rs2.getInt("count(*)") > 0 ? item_rs1.getInt("auctionId") + 1 : 1));
    pst.setString(7, "" + itemID);
    //System.out.println()
	
	pst.executeUpdate();
    
    
   	
   	//create relationship(sells) between user and auction
   	sell_statement.setString(1, userName);
   	sell_statement.setString(2, "" + auctionID);
   	sell_statement.executeUpdate();
	
	
	
	response.sendRedirect("main.jsp");
	%>
</body>
</html>