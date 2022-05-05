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
		ResultSet auctions = st.executeQuery("SELECT DISTINCT a.* FROM Sells s, Auction a, Users u WHERE s.username = '" 
		+ session.getAttribute("user") + "' AND s.auctionId =  a.auctionId;");
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
		out.println("All Active Auctions");
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
		
		
		
		Statement bid_st = con.createStatement();
		ResultSet yourBids = bid_st.executeQuery("select b.auctionId, a.itemName, Max(b.amount), a.closeDateTime, b.upperLimit, b.increment FROM bids b, auction a where a.auctionId = b.auctionId and b.username = '" 
		+ session.getAttribute("user") + "'");
		
				
		ResultSetMetaData bet_rsmd = yourBids.getMetaData();
		colCount = rsmd.getColumnCount();
				
		out.println("<P ALIGN='center'><TABLE BORDER=1>");
		out.println("Your Bids");
		out.println("<TR>");
				
		out.println("<TH>" + "Auction ID#" + "</TH>");
		out.println("<TH>" + "Item Name" + "</TH>");
		out.println("<TH>" + "Your bid" + "</TH>");
		out.println("<TH>" + "Highest bid" + "</TH>");
		out.println("<TH>" + "Leading User" + "</TH>");
		out.println("<TH>" + "Closing Date" + "</TH>");
		out.println("<TH>" + "Closing time" + "</TH>");
		out.println("<TH>" + "Auto Bid" + "</TH>");
		
		
		
		
		
		
		out.println("</TR>");
		if(yourBids != null){
			while (yourBids.next()) {
				out.println("<TR>");
				int aucId = Integer.parseInt(yourBids.getString(1));
				for (int i = 0; i < colCount + 1; i++) { //this loop is super redundant lol
					
					if(i == 0){
			    		//out.println("<TD>" + "<a href='displayAuction.jsp' data=>" + auctions.getString(i + 1) + "</a> " + "</TD>");
			    		%> <TD><a href=<%= "\"displayAuction.jsp?Id=" + yourBids.getString(i + 1) + "\"" %> ><%= yourBids.getString(i + 1) %></a></TD><%
			    		//TODO: SET LINK(S) TO DISPLAY AUCTION JSP WHEN MADE
			    	}else if(i == 1){
			    		out.println("<TD>" + yourBids.getString(i + 1) + "</TD>");
			    	}else if(i == 2){
			    		out.println("<TD>" + "$" +  f.format(yourBids.getFloat(i + 1)) + "</TD>");
			    	}else if(i == 3){
			    		
			    		PreparedStatement ps = con.prepareStatement("Select MAX(b.amount), b.username FROM Bids b, Auction a WHERE b.auctionId =?");
					  	ps.setString(1, "" + aucId);
					  	ResultSet maxBid = ps.executeQuery();
					  	maxBid.next();
			    		float maxBidNum;
			    		String leadingBidder;
			    		if(maxBid.getString(1) == null){
					  		ps = con.prepareStatement("Select initialPrice FROM Auction WHERE auctionId=?");
					  		ps.setString(1, "" + aucId);
					  		ResultSet init = ps.executeQuery();
					  		init.next();
					  		maxBidNum = init.getFloat(1);
					  		leadingBidder = "'No Bids Placed'";
					  	}else{
					  		maxBidNum = Float.parseFloat(maxBid.getString(1));
					  		leadingBidder = maxBid.getString(2);
					  	}
					  	
					  	out.println("<TD>" + "$" + f.format(maxBidNum) + "</TD>");
					  	out.println("<TD>" + leadingBidder + "</TD>");
			    	}else if(i == 4){
			    		
			    		String date = yourBids.getString(i);
			    		StringBuffer sbf = new StringBuffer(date); 
			    		sbf.deleteCharAt(19);					
			    		sbf.deleteCharAt(19);
			    		String closeTime = sbf.toString();
			    		String dt[] = closeTime.split(" ");
			    		LocalDateTime closeDate = LocalDateTime.parse(closeTime, dateForm);
			    		LocalDateTime curTime = LocalDateTime.now();
			    		
			    		if(curTime.isAfter(closeDate)){
			    			out.println("<TD>" + "CLOSED" + "</TD>");
				    		out.println("<TD>" + "CLOSED" + "</TD>");
			    		}else{
			    			out.println("<TD>" + dt[0] + "</TD>");
			    			out.println("<TD>" + dt[1] + "</TD>");
			    		}
			    		
			    		
			    		
			    		
			    	}else if(i == 5){
			    		if(yourBids.getString(i) == null && yourBids.getString(i+1) == null){
			    			out.println("<TD>" + "DISABLED" + "</TD>");
			    		}else{
			    			out.println("<TD>" + "ENABLED" + "</TD>");
			    		}
			    		
			    	}else{
			    		//out.println("<TD>" + yourBids.getString(i + 1) + "</TD>");
			    	}
				}
			}
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