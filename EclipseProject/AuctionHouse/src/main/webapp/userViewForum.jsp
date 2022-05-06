<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Yours Questions</title>
</head>
<body>

<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	String curUser = (String)session.getAttribute("user");
		
%>	
	<span style="font-size:24px">Your Questions</span></br>
	<p>
	<span style="font-size:18px">Post New Question</span></br>
	<form action="submitQ.jsp">
		<textarea id="questionText" name="questionText" rows="6" cols="70" maxlength="199">Ask a question to be answered by a sale representative.</textarea></br>
		<input type="submit" value="Submit">
	</form>
	<p>
	
	
	<span style="font-size:18px">Unanswered Questions</span></br>
	
	<%
		String getPosts = "select postId, question from Posts where username = '" + curUser + "' AND answer IS NULL order by postId desc";
		
		
		Statement getSt = con.createStatement();
		ResultSet unanswered_posts = getSt.executeQuery(getPosts);
		
		if(unanswered_posts.next()){
			//out.print("------------------------------------------------------------");
			%><br><span style="font-size:16px"><% out.print("Question ID#: " + unanswered_posts.getInt(1));%></span> <%
			%><br><span style="font-size:16px"><% out.print("Question: " + unanswered_posts.getString(2));%></span></br> <%
			
			
			while(unanswered_posts.next()){
				out.print("------------------------------------------------------------");
				%><br> <%
				%><br><span style="font-size:16px"><% out.print("Question ID#: " + unanswered_posts.getInt(1));%></span> <%
				%><br><span style="font-size:16px"><% out.print("Question: " + unanswered_posts.getString(2));%></span></br> <%
				out.print("------------------------------------------------------------");
				%><br> <%
	
			}
			
		}else{
			%><span style="font-size:16px">No Unanswered Questions</span></br> <% 
		}
	
	
	
	
	
	%>
	<p>
	<span style="font-size:20px">Answered Questions</span></br>
	<p>
	
	<%
	String getAnswered = "select postId, question, answer, employee from Posts where username = '" + curUser + "' AND answer IS NOT NULL order by postId desc";
	
	Statement getASt = con.createStatement();
	ResultSet answered_posts = getASt.executeQuery(getAnswered);
	
	if(answered_posts.next()){
		//out.print("------------------------------------------------------------");
		%><br><span style="font-size:16px"><% out.print("Question ID#: " + answered_posts.getInt(1));%></span> <%
		%><br><span style="font-size:16px"><% out.print("Question: " + answered_posts.getString(2));%></span></br> <%
		%><br><span style="font-size:16px"><% out.print("Answer: " + answered_posts.getString(3));%></span></br> <%
		%><span style="font-size:16px"><% out.print("- " + answered_posts.getString(4));%></span></br> <%
		
		while(answered_posts.next()){
			out.print("------------------------------------------------------------");
			%><br> <%
			%><br><span style="font-size:16px"><% out.print("Question ID#: " + answered_posts.getInt(1));%></span> <%
			%><br><span style="font-size:16px"><% out.print("Question: " + answered_posts.getString(2));%></span></br> <%
			%><br><span style="font-size:16px"><% out.print("Answer: " + answered_posts.getString(3));%></span></br> <%
			%><<span style="font-size:16px"><% out.print("- " + answered_posts.getString(4));%></span></br> <%
			out.print("------------------------------------------------------------");
			%><br> <%

		}
		
	}else{
		%><span style="font-size:16px">No Answers Available</span></br><p> <% 
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	%>
	
<a href='main.jsp'>Return</a>
</body>
</html>