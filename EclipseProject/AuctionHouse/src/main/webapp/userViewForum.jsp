<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Question-and-Answer Forum</title>
	<style>
		span {
			font-size: 18px;
			font-weight: bold;
		}
		table {
			border-collapse: collapse;
			table-layout: fixed;
			width: 1000px;
		}
		table td {
			word-wrap: break-word;
		}
	</style>
</head>
<body>
	<a href='main.jsp'>Return to Main</a><br/><br/>
	<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse", "root", "root");
	String user = (String)session.getAttribute("user");

	
	//ASK A QUESTION
	%>
	<span>Post a New Question</span><br/>
	<form action="submitQ.jsp">
		<textarea name="question" rows="6" cols="70" maxlength="199" placeholder="Ask a question to be answered by a sale representative."></textarea><br/>
		<input type="submit" value="Submit">
	</form>
	
	
	
	
	
	<%
	//YOUR POSTS
	
	//get posts created by user
	Statement ypSt = con.createStatement();
	ResultSet yourPosts = ypSt.executeQuery("SELECT * FROM Posts WHERE username = '" + user + "'");
	
	out.print("<p><table border=1>");
	out.print("<span>Your Questions</span><br/>");
	
	out.print("<tr>");
	out.print("<th width='10%'>Post ID#</th>");
	out.print("<th width='40%'>Question</th>");
	out.print("<th width='40%'>Answer</th>");
	out.print("<th width='10%'>Employee</th>");
	out.print("</tr>");
	
	while (yourPosts.next()) {
		int postId = yourPosts.getInt(1);
		String question = yourPosts.getString(4);
		String answer = (yourPosts.getString(5) != null) ? yourPosts.getString(5) : "";
		String employee = (yourPosts.getString(3) != null) ? yourPosts.getString(3) : "";
		
		out.print("<tr>");
		
		out.print("<td>" + postId + "</td>");
		out.print("<td>" + question + "</td>");
		out.print("<td>" + answer + "</td>");
		out.print("<td>" + employee + "</td>");
		
	  	out.print("</tr>");
	}
	out.print("</table></p>");
	
	
	
	
	
	//ALL POSTS
	
	//get all posts
	String query = "SELECT * FROM Posts";
	
	//search by keyword
	String search = (request.getParameter("search") != null) ? request.getParameter("search") : "";
	if (!search.isEmpty()) {
		query += " WHERE question LIKE '%" + search + "%'";
	}
	
	Statement pSt = con.createStatement();
	ResultSet posts = pSt.executeQuery(query);
	
	
	out.print("<p><table border=1>");
	out.print("<span>All Questions and Answers</span><br/>");
	%>
	
	<form method="GET" action="userViewForum.jsp">
		Search: <input type="text" name="search" placeholder="keywords" value="<%=search%>"/>
		<input type="submit" value="Submit"/>
	</form>
	
	<%
	out.print("<tr>");
	out.print("<th width='10%'>Post ID#</th>");
	out.print("<th width='40%'>Question</th>");
	out.print("<th width='40%'>Answer</th>");
	out.print("<th width='10%'>Employee</th>");
	out.print("</tr>");
	
	while (posts.next()) {
		int postId = posts.getInt(1);
		String question = posts.getString(4);
		String answer = (posts.getString(5) != null) ? posts.getString(5) : "";
		String employee = (posts.getString(3) != null) ? posts.getString(3) : "";
		
		out.print("<tr>");
		
		out.print("<td>" + postId + "</td>");
		out.print("<td>" + question + "</td>");
		out.print("<td>" + answer + "</td>");
		out.print("<td>" + employee + "</td>");
		
	  	out.print("</tr>");
	}
	out.print("</table></p>");
	%>
</body>
</html>