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
    
    
    String sn = request.getParameter("serialNum");
    String bran = request.getParameter("brand");
    String mod = request.getParameter("model");
    String year = request.getParameter("year");
    String cpu = request.getParameter("cpu");
    String gpu = request.getParameter("gpu");
    String ram = request.getParameter("ram");
    String screenSize = request.getParameter("size");
    String touch = request.getParameter("touch");
    String cam = request.getParameter("camera");
    String storage = request.getParameter("storage");
    String chip = request.getParameter("chip");
    
    //in mysql you can to field = null   :))))))))))) 

    if(sn == null){
    	sn = "IS NULL";
    }
    if(bran == null){
    	bran = "IS NULL";
    }
    if(mod == null){
    	mod = "IS NULL";
    }
    if(year == null){
    	year = "IS NULL";
    }
    if(cpu == null){
    	cpu = "IS NULL";
    }
    if(gpu == null){
    	gpu = "IS NULL";
    }
    if(ram == null){
    	ram = "IS NULL";
    }
    if(screenSize == null){
    	screenSize = "IS NULL";
    }
    if(touch == null){
    	touch = "IS NULL";
    }
    if(cam == null){
    	cam = "IS NULL";
    }
    if(storage == null){
    	storage = "IS NULL";
    }
    if(chip == null){
    	chip = "IS NULL";
    }
        
    Statement doesItemExist = con.createStatement(); 
	int itemID;
    boolean newItem = true;
	ResultSet checkSet;
	
    if(sn.equals("IS NULL")){
    	checkSet = doesItemExist.executeQuery(" select * from electronics where serialNumber " + sn + "");
    }else{
    	checkSet = doesItemExist.executeQuery(" select * from electronics where serialNumber = '" + sn + "'");
    }
    
    
    if(checkSet.next() ){
    	if(bran.equals("IS NULL")){
    		checkSet = doesItemExist.executeQuery(" select * from electronics where brand " + bran + "");
    	}else{
    		checkSet = doesItemExist.executeQuery(" select * from electronics where brand = '" + bran + "'");
    	}
    	
    	if(checkSet.next() ){
    		
    		if(mod.equals("IS NULL")){
    			checkSet = doesItemExist.executeQuery(" select * from electronics where model " + mod + "");
	    	}else{
	    		checkSet = doesItemExist.executeQuery(" select * from electronics where model = '" + mod + "'");
	    	}
    	
    		if(checkSet.next() ){
    			if(year.equals("IS NULL")){
        			checkSet = doesItemExist.executeQuery(" select * from electronics where year " + year + "");
    	    	}else{
    	    		checkSet = doesItemExist.executeQuery(" select * from electronics where year = '" + year + "'");
    	    	}
    			
    			if(checkSet.next() ){
    				
    				if(cpu.equals("IS NULL")){
            			checkSet = doesItemExist.executeQuery(" select * from electronics where cpu " + cpu + "");
        	    	}else{
        	    		checkSet = doesItemExist.executeQuery(" select * from electronics where cpu = '" + cpu + "'");
        	    	}
    				
    				if(checkSet.next() ){
    					if(gpu.equals("IS NULL")){
                			checkSet = doesItemExist.executeQuery(" select * from electronics where gpu " + gpu + "");
            	    	}else{
            	    		checkSet = doesItemExist.executeQuery(" select * from electronics where gpu = '" + gpu + "'");
            	    	}
    					
    					if(checkSet.next() ){
    						if(ram.equals("IS NULL")){
                    			checkSet = doesItemExist.executeQuery(" select * from electronics where ram " + ram + "");
                	    	}else{
                	    		checkSet = doesItemExist.executeQuery(" select * from electronics where ram = '" + ram + "'");
                	    	}
    						
    						if(checkSet.next() ){
    							if(screenSize.equals("IS NULL")){
                        			checkSet = doesItemExist.executeQuery(" select * from electronics where screenSize " + screenSize + "");
                    	    	}else{
                    	    		checkSet = doesItemExist.executeQuery(" select * from electronics where screenSize = '" + screenSize + "'");
                    	    	}
    							
    							if(checkSet.next() ){
    								if(touch.equals("IS NULL")){
                            			checkSet = doesItemExist.executeQuery(" select * from electronics where touchScreen " + touch + "");
                        	    	}else{
                        	    		checkSet = doesItemExist.executeQuery(" select * from electronics where touchScreen = '" + touch + "'");
                        	    	}
    								
    								if(checkSet.next() ){
        								if(cam.equals("IS NULL")){
                                			checkSet = doesItemExist.executeQuery(" select * from electronics where camera " + cam + "");
                            	    	}else{
                            	    		checkSet = doesItemExist.executeQuery(" select * from electronics where camera = '" + cam + "'");
                            	    	}
        								
        								if(checkSet.next() ){
            								if(storage.equals("IS NULL")){
                                    			checkSet = doesItemExist.executeQuery(" select * from electronics where storage " + storage + "");
                                	    	}else{
                                	    		checkSet = doesItemExist.executeQuery(" select * from electronics where storage = '" + storage + "'");
                                	    	}
            								
            								if(checkSet.next() ){
                								if(chip.equals("IS NULL")){
                                        			checkSet = doesItemExist.executeQuery(" select * from electronics where chip " + chip + "");
                                    	    	}else{
                                    	    		checkSet = doesItemExist.executeQuery(" select * from electronics where chip = '" + chip + "'");
                                    	    	}
            								}		
        								}		
    								}	
    							}	
    						}
    					} 					
    				}	
    			}	
    		}
    	}
    	
    if(checkSet.next()){
    	 itemID =  Integer.parseInt(checkSet.getString(1));
    	 newItem = false;
    }else{
    	Statement getItemID = con.createStatement();
		   Statement getItemID2 = con.createStatement();
		   ResultSet item_rs1 = getItemID.executeQuery("SELECT max(itemId) FROM Electronics");
		   //ResultSet item_rs2 = getItemID.executeQuery("SELECT count(*) FROM Electronics");
		   ResultSet item_rs2 = getItemID2.executeQuery("SELECT count(*) FROM Electronics");
		   item_rs1.next();
		   item_rs2.next();
		   itemID = (item_rs2.getInt("count(*)") > 0 ? item_rs1.getInt("MAX(itemId)") + 1 : 1); //save itemID for electronics query
    }

    //int itemID;		
    //if(matchingItem.next()){
    //	itemID = matchingItem.getInt(1);
    
    }else{
    	
    
    
		   Statement getItemID = con.createStatement();
		   Statement getItemID2 = con.createStatement();
		   ResultSet item_rs1 = getItemID.executeQuery("SELECT max(itemId) FROM Electronics");
		   //ResultSet item_rs2 = getItemID.executeQuery("SELECT count(*) FROM Electronics");
		   ResultSet item_rs2 = getItemID2.executeQuery("SELECT count(*) FROM Electronics");
		   item_rs1.next();
		   item_rs2.next();
		   itemID = (item_rs2.getInt("count(*)") > 0 ? item_rs1.getInt("MAX(itemId)") + 1 : 1); //save itemID for electronics query
    } 
    if(newItem){
	    //TODO: clean up
    	item_statement.setString(1, "" + itemID);
	    item_statement.setString(2, (request.getParameter("serialNum") != null && !request.getParameter("serialNum").isEmpty()) ? request.getParameter("serialNum") : "-1");
	    item_statement.setString(3, (request.getParameter("brand") != null && !request.getParameter("brand").isEmpty()) ? request.getParameter("brand") : "not provided");
	    item_statement.setString(4, (request.getParameter("model") != null && !request.getParameter("model").isEmpty()) ? request.getParameter("model") : "not provided");
	    item_statement.setString(5, (request.getParameter("year") != null && !request.getParameter("year").isEmpty()) ? request.getParameter("year") : "-1");
	    item_statement.setString(6, (request.getParameter("cpu") != null && !request.getParameter("cpu").isEmpty()) ? request.getParameter("cpu") : "not provided");
	    item_statement.setString(7, (request.getParameter("gpu") != null && !request.getParameter("gpu").isEmpty()) ? request.getParameter("gpu") : "not provided");
	    item_statement.setString(8, (request.getParameter("ram") != null && !request.getParameter("ram").isEmpty()) ? request.getParameter("ram") : "not provided");
	    item_statement.setString(9, (request.getParameter("size") != null && !request.getParameter("size").isEmpty()) ? request.getParameter("size") : "-1");
	    item_statement.setString(10, (request.getParameter("touch") != null && !request.getParameter("touch").isEmpty()) ? request.getParameter("touch") : "0");
	    item_statement.setString(11, (request.getParameter("camera") != null && !request.getParameter("camera").isEmpty()) ? request.getParameter("camera") : "not provided");
	    item_statement.setString(12, (request.getParameter("storage") != null && !request.getParameter("storage").isEmpty()) ? request.getParameter("storage") : "-1");
	    item_statement.setString(13, (request.getParameter("chip") != null && !request.getParameter("chip").isEmpty()) ? request.getParameter("chip") : "not provided");
	   	item_statement.executeUpdate();
    }     
    Statement st = con.createStatement();
    Statement st2 = con.createStatement();
    ResultSet rs1 = st.executeQuery("SELECT max(auctionId) FROM Auction");
    ResultSet rs2 = st2.executeQuery("SELECT count(*) FROM Auction");
    rs1.next();
    rs2.next();
    int auctionID = (rs2.getInt("count(*)") > 0 ? rs1.getInt("MAX(auctionId)") + 1 : 1); //need for Sells
    //pst.setString(1, "" + (rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1));
    pst.setString(1, "" + auctionID);
    //out.print(rs2.getInt("count(*)") > 0 ? rs1.getInt("auctionId") + 1 : 1);
    
    pst.setString(2, request.getParameter("itemName"));
    
	pst.setString(3, (request.getParameter("minPrice") != null && !request.getParameter("minPrice").isEmpty()) ? request.getParameter("minPrice") : "-1");
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