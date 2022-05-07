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
<title>Edit Account Details</title>
</head>
<body>
	
<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	String editUser = request.getParameter("usr");
%>	
	<span style="font-size:24px"><%out.println("Edit User");%></span><br><p>
	<form action="editUser.jsp">
	<span style="font-size:16px">Change Username, Password or Both of Account</span><br>
	New Username: <input type="text" name="username"/><br/>
	New Password: <input type="text" name="password"/><br/>
	<% session.setAttribute("usrr", editUser); %>
	<input type="submit" name="Update" value="Update"/>
	</form>
	
	<br>
	<form action="deleteAuction.jsp">	
	<span style="font-size:16px">Enter Auction # to Delete</span><br>
	<input type="text" id="aucId" name="aucId">
	<input type="submit" name="Delete" value="Delete"/>
	</form>
	
	
	
	
	
	
	
	<% 
	Statement st = con.createStatement();
	ResultSet auctions = st.executeQuery("SELECT DISTINCT a.* FROM Sells s, Auction a WHERE s.username = '" + editUser + "' AND s.auctionId =  a.auctionId;");
	
	
	ResultSetMetaData rsmd = auctions.getMetaData();
	int colCount = rsmd.getColumnCount();
	out.println("<P ALIGN='center'><TABLE BORDER=1>");
	out.print("<span style='font-size: 18px;'> User Auctions</span><br>");
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
	    		 
	    		out.println("<TD>" + auctions.getString(i + 1) + "</TD>");
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
	%> 
	
	<br>
	<form action="deleteBid.jsp">	
	<span style="font-size:16px">Enter Bid # to Delete</span><br>
	<input type="text" id="bidId" name="bidId">
	<input type="submit" name="Delete" value="Delete"/>
	</form>
	
	<% 
	
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
	out.print("<span style='font-size: 18px;'>User Active Bids</span><br>");
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
		    		
		    				out.println("<TD>" + yourBids.getString(i + 1) + "</TD>");
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
	
	
	
<%

//if(!(String)session.getAttribute("usrr").equals(null) ){
//	session.removeAttribute("usrr");
//}
	


%>
	<p><br><a href='saleRep.jsp'>Return</a>
	
</body>
</html>