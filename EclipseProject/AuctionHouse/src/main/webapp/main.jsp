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
	</form><br>
				
	<%
	//TODO: alert auto bidders when upperLimit reached
    //TOOD: alert normal bidders when surpassed
    //TODO: alert winner that they won
    //TODO: alert when item becomes available
    
    out.print("<span style='font-size: 18px;'>Post and View Questions<br>");
	out.print("<a href='userViewForum.jsp'>Enter Forum</a><p></p>");
    
    Statement st = con.createStatement();
	ResultSet recentAlerts = st.executeQuery("SELECT * FROM Alerts WHERE username='" + session.getAttribute("user") +
			"' AND dateTime BETWEEN date_sub(now(), INTERVAL 1 WEEK) and now()");
    out.print("<span style='font-size: 18px;'>Recent Alerts</span> (within the last week)<br>");
    if (recentAlerts.next()) {
    	out.print("<table border=1>");
        do {
        	out.print("<tr><td>");
        	out.print(recentAlerts.getString(3));
        	out.print("</td></tr>");
        } while (recentAlerts.next());
	    out.print("</table>");
    } else {
    	out.print("No new alerts.<br>");
    }
	out.print("<a href='alerts.jsp'>Show all alerts</a>");
	
	
	ResultSet auctions = st.executeQuery("SELECT DISTINCT a.* FROM Sells s, Auction a WHERE s.username = '" 
			+ session.getAttribute("user") + "' AND s.auctionId =  a.auctionId;");
	//SELECT s.username FROM Sells s, Auction a where s.auctionId = a.auctionId;
	
	ResultSetMetaData rsmd = auctions.getMetaData();
	int colCount = rsmd.getColumnCount();
	out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.print("<span style='font-size: 18px;'>Your Auctions</span><br>");
	out.println("<TR>");
			
	out.println("<TH>" + "Auction ID#" + "</TH>");
	out.println("<TH>" + "Item ID#" + "</TH>");
	out.println("<TH>" + "Item Name" + "</TH>");
	out.println("<TH>" + "Minimum Price" + "</TH>");
	out.println("<TH>" + "Initial Price" + "</TH>");
	out.println("<TH>" + "Bid Increment" + "</TH>");
	out.println("<TH>" + "Closing Date & Time" + "</TH>");
	
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
		PreparedStatement ps = con.prepareStatement("SELECT MAX(amount) FROM Bids WHERE auctionId=?");
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
	out.print("<span style='font-size: 18px;'>All Active Auctions</span><br>");
	out.println("<TR>");
	out.println("<TH>" + "Auction ID#" + "</TH>");
	out.println("<TH>" + "Item ID#" + "</TH>");
	out.println("<TH>" + "Item Name" + "</TH>");
	//non their auction so doenst need to see
	//out.println("<TH>" + "Minimum Price" + "</TH>");
	//out.println("<TH>" + "Initial Price" + "</TH>");
	//out.println("<TH>" + "Bid Increment" + "</TH>");
	out.println("<TH>" + "Closing Date & Time" + "</TH>");
	
	
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
		PreparedStatement ps = con.prepareStatement("SELECT MAX(amount) FROM Bids WHERE auctionId=?");
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
	String query = "SELECT a.auctionId, a.itemName, b.amount, a.closeDateTime, b.upperLimit, b.increment" +
			" FROM Bids b, Auction a" +
			" WHERE b.auctionId = a.auctionId AND bidId IN (SELECT MAX(bidId) FROM Bids WHERE username='" + session.getAttribute("user") + "' GROUP BY username, auctionId)";
	ResultSet yourBids = bid_st.executeQuery(query);
	//select a.auctionId, a.itemName, b.amount, a.closeDateTime, b.upperLimit, b.increment
	//from bids b, auction a
	//where b.auctionId = a.auctionId and bidId in (select max(bidId) from bids where username='test3' group by username, auctionId);
	
			
	ResultSetMetaData bet_rsmd = yourBids.getMetaData();
	colCount = rsmd.getColumnCount();
			
	out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.print("<span style='font-size: 18px;'>Your Active Bids</span><br>");
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
			if (yourBids.getString(1) == null) break;
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
		    		
		    		PreparedStatement ps = con.prepareStatement("SELECT amount, username FROM Bids WHERE amount = (SELECT MAX(amount) FROM Bids WHERE auctionId=?) AND auctionId=?");
		    	  	ps.setString(1, "" + aucId);
		    	  	ps.setString(2, "" + aucId);
				  	ResultSet maxBid = ps.executeQuery();
				  	maxBid.next();
		    		float maxBidNum;
		    		String leadingBidder;
		    		if(maxBid.getString(1) == null){
				  		ps = con.prepareStatement("SELECT initialPrice FROM Auction WHERE auctionId=?");
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
	
	<form method="POST">
		<input type="hidden" name="user" value="<%=session.getAttribute("user")%>"/>
		<input type="submit" name="delete" formaction="deleteUser.jsp" value="Delete Account"/>
		<input type="submit" name="logout" formaction="logout.jsp" value="Log Out"/>
	</form>
	<%
	}
	%>
	
</body>
</html>