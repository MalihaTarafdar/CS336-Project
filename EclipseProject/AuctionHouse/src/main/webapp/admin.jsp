<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin</title>
</head>
<body>
	
	<p>
	<span style="font-size:24px">Administrator</span><br/>
	<span style="font-size:18px">Create Customer Representative Account</span><br/>
	<form method="POST" action="loginRegister.jsp">
		Username: <input type="text" name="username"/><br/>
    	Password: <input type="password" name="password"/><br/>
    	<button type="submit" formaction="createSalesRep.jsp">Create</button><br/>
    </form>
    </p>
	<p>
	
	
	<form>
		<span style="font-size:18px">Sales Reports:</span><br/>
		<button type="submit" formaction="report_totalEarnings.jsp">Generate Total Earnings Report</button><br/>
		<button type="submit" formaction="perItem.jsp">Generate Earnings Item</button><br/>
		<button type="submit" formaction="perItemType.jsp">Generate Earnings per Item-Type</button><br/>
		<button type="submit" formaction="report_totalEarnings.jsp">Generate Earnings per end-user</button><br/>
		<button type="submit" formaction="report_totalEarnings.jsp">Generate Best Selling Items Report</button><br/>
		<button type="submit" formaction="report_totalEarnings.jsp">Generate Best Buyers Report</button><br/>
		
		
	</form>
	
	
	</p>
	<% //PreparedStatement item_statement = con.prepareStatement("INSERT INTO Electronics %>
<a href='logout.jsp'>Log out</a>

</body>
</html>