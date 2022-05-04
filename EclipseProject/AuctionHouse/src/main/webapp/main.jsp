<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>AuctionHouse</title>
</head>
<body>
	<%
	Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	
	if (session.getAttribute("user") == null) {
	%>
		You are not logged in<br/>
		<a href="index.jsp">Please Login</a>
	<%} else {
	%>
		Welcome <%=session.getAttribute("user")%><br>
		
		<label for="electronic">Choose type of electronic:</label>
		<form method="POST" action="addAuction.jsp">
			<select name="electronic" id="type">
			  <option value="PC">PC</option>
			  <option value="Laptop/Tablet">Laptop/Tablet</option>
			  <option value="Phone">Phone</option>
			</select>
			<input type="submit" value="Add Auction"/>
		</form>
				
		<%
		
		Statement st = con.createStatement();
		ResultSet auctions = st.executeQuery("SELECT a.* FROM Sells s, Auction a, Users u WHERE u.username = s.username AND s.auctionId =  a.auctionId;");
		//SELECT s.username FROM Sells s, Auction a where s.auctionId = a.auctionId;
		
		ResultSetMetaData rsmd = auctions.getMetaData();
		int colCount = rsmd.getColumnCount();
		out.println("<P ALIGN='center'><TABLE BORDER=1>");
		out.println("Your Auctions");
		out.println("<TR>");
				
		out.println("<TH>" + "Auction ID#" + "</TH>");
		out.println("<TH>" + "Item ID#" + "</TH>");
		out.println("<TH>" + "Item Name" + "</TH>");
		out.println("<TH>" + "Minimum Price" + "</TH>");
		out.println("<TH>" + "Initial Price" + "</TH>");
		out.println("<TH>" + "Bid Increment" + "</TH>");
		out.println("<TH>" + "Closing Date & Time)" + "</TH>");
		
		DecimalFormat f = new DecimalFormat("#0.00");
		DateTimeFormatter dateForm = DateTimeFormatter.ofPattern("yyyy-dd-MM HH:mm:ss");
		//INSERT MAX BID HEADER HERE
		out.println("<TH>" + "Highest Bid" + "</TH>");
		 
		out.println("</TR>");
		 // the data
		while (auctions.next()) {
			out.println("<TR>");
		  	for (int i = 0; i < colCount; i++) {
		    	
		    	if(i == 0){
		    		//out.println("<TD>" + "<a href='displayAuction.jsp' data=>" + auctions.getString(i + 1) + "</a> " + "</TD>");
		    		%> <TD><a href=<%= "\"displayAuction.jsp?Id=" + auctions.getString(i + 1) + "\"" %> ><%= auctions.getString(i + 1) %></a></TD><% 
		    		
		    	}else if(i == 3 || i == 4 || i == 5){
		    		out.println("<TD>" + "$" + f.format(Float.parseFloat(auctions.getString(i + 1))) + "</TD>");
		    	}else{
		    		out.println("<TD>" + auctions.getString(i + 1) + "</TD>");
		    	}
		    	
		    }
		  	int aucId = Integer.parseInt(auctions.getString(1));
			PreparedStatement ps = con.prepareStatement("Select MAX(b.amount) FROM Bids b, Auction a WHERE b.auctionId =?");
		  	ps.setString(1, "" + aucId);
		  	ResultSet maxBid = ps.executeQuery();
		  	maxBid.next();
		  	float maxBidNum;
		  	if(maxBid.getString(1) == null){
		  		ps = con.prepareStatement("Select initialPrice FROM Auction WHERE auctionId=?");
		  		ps.setString(1, "" + aucId);
		  		ResultSet init = ps.executeQuery();
		  		init.next();
		  		maxBidNum = init.getFloat(1);
		  	}else{
		  		maxBidNum = Float.parseFloat(maxBid.getString(1));
		  	}
		  	
		  	out.println("<TD>" + "$" + f.format(maxBidNum) + "</TD>");
		  
		  	out.println("</TR>");
		}
		out.println("</TABLE></P>");
		 
		 
		auctions = st.executeQuery("SELECT * FROM Auction;");
			//SELECT s.username FROM Sells s, Auction a where s.auctionId = a.auctionId;
			
		rsmd = auctions.getMetaData();
		colCount = rsmd.getColumnCount();
		out.println("<P ALIGN='center'><TABLE BORDER=1>");
		out.println("All Auctions");
		out.println("<TR>");
		out.println("<TH>" + "Auction ID#" + "</TH>");
		out.println("<TH>" + "Item ID#" + "</TH>");
		out.println("<TH>" + "Item Name" + "</TH>");
		//non their auction so doenst need to see
		//out.println("<TH>" + "Minimum Price" + "</TH>");
		//out.println("<TH>" + "Initial Price" + "</TH>");
		//out.println("<TH>" + "Bid Increment" + "</TH>");
		out.println("<TH>" + "Closing Date & Time)" + "</TH>");
		
		
		//INSERT MAX BID HEADER HERE
		out.println("<TH>" + "Highest Bid" + "</TH>");
		out.println("</TR>");
		// the data
		while (auctions.next()) {
			out.println("<TR>");
			for (int i = 0; i < colCount; i++) {
				if(i == 3){
					i=6;
				}
				if(i == 0){
		    		//out.println("<TD>" + "<a href='displayAuction.jsp' data=>" + auctions.getString(i + 1) + "</a> " + "</TD>");
		    		%> <TD><a href=<%= "\"displayAuction.jsp?Id=" + auctions.getString(i + 1) + "\"" %> ><%= auctions.getString(i + 1) %></a></TD><%
		    		//TODO: SET LINK(S) TO DISPLAY AUCTION JSP WHEN MADE
		    	}else{
		    		out.println("<TD>" + auctions.getString(i + 1) + "</TD>");
		    	}
			}
			int aucId = Integer.parseInt(auctions.getString(1));
			PreparedStatement ps = con.prepareStatement("Select MAX(b.amount) FROM Bids b, Auction a WHERE b.auctionId =?");
		  	ps.setString(1, "" + aucId);
		  	ResultSet maxBid = ps.executeQuery();
		  	maxBid.next();
		  	float maxBidNum;
		  	if(maxBid.getString(1) == null){
		  		ps = con.prepareStatement("Select initialPrice FROM Auction WHERE auctionId=?");
		  		ps.setString(1, "" + aucId);
		  		ResultSet init = ps.executeQuery();
		  		init.next();
		  		maxBidNum = init.getFloat(1);
		  	}else{
		  		maxBidNum = Float.parseFloat(maxBid.getString(1));
		  	}
		  	
		  	out.println("<TD>" + "$" + f.format(maxBidNum) + "</TD>");
			out.println("</TR>");
			}
		out.println("</TABLE></P>");
		
		
		
		%>
		
		
		
		
		
		<a href='deleteUser.jsp'>Delete Account</a>
		<a href='logout.jsp'>Log out</a>
	<%
	}
	%>
	
</body>
</html>