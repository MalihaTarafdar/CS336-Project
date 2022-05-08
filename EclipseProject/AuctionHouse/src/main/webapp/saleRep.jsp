<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sale Rep <% out.print(session.getAttribute("user"));%> </title>
</head>
<body>

<span style="font-size:24px">Welcome <% out.print(session.getAttribute("user"));%></span><br>


<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/AuctionHouse","root", "root");
	String curUser = (String)session.getAttribute("user"); 
	
	
	
	%>
	
	<form action="editAccount.jsp">
	<span style="font-size:16px">Enter User To Edit</span><br>
	<input type="text" id="usr" name = "usr"><br>
	<input type="submit" value="Submit"><br>
	</form>
	<%
	
	
	
	
	
	
	String getPosts = "select postId, question from Posts where answer IS NULL order by postId desc";
	Statement getSt = con.createStatement();
	ResultSet unanswered_posts = getSt.executeQuery(getPosts);
	
	
	%><p><span style="font-size:20px">Answer User Questions</span> <%
	if(unanswered_posts.next()){
		//out.print("------------------------------------------------------------");
		
		%><br><span style="font-size:16px"><% out.print("Question ID#: " + unanswered_posts.getInt(1));%></span> <%
		%><br><span style="font-size:16px"><% out.print("Question: " + unanswered_posts.getString(2));%></span></br> <%
		
		
		%><form action="submitA.jsp" method="post">
		<textarea id="answerText" name="answerText" rows="4" cols="70" maxlength="199" placeholder="Answer Question"></textarea></br>
		<%session.setAttribute("postId", unanswered_posts.getInt(1)); %> 
		<input type="submit" value="Submit">
		</form> 
		<%
		
		
		while(unanswered_posts.next()){
			
			out.print("------------------------------------------------------------");
			%><br> <%
			%><br><span style="font-size:16px"><% out.print("Question ID#: " + unanswered_posts.getInt(1));%></span> <%
			%><br><span style="font-size:16px"><% out.print("Question: " + unanswered_posts.getString(2));%></span></br> <%
			%><form action="submitA.jsp" method="post">
			<textarea id="answerText" name="answerText" rows="4" cols="70" maxlength="199" placeholder="Answer Question"></textarea></br>
			<%session.setAttribute("postId", unanswered_posts.getInt(1)); %>
			<input type="submit" value="Submit">
			</form> 
			<%
			
			out.print("------------------------------------------------------------");
			%><br> <%

		}
		
	}else{
		%><br><span style="font-size:16px">No Unanswered Questions</span></br> <% 
	}
	



%>

<p><br><a href='logout.jsp'>Log out</a>


</body>
</html>