<%-- 
    Document   : invalid
    Created on : Feb 13, 2025, 1:55:51 PM
    Author     : cbao
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%@include file="header.jsp" %>
        <div style="min-height: 500px; padding: 20px">
            <h1>
                <font color="red">
                Invalid Username or Password!
                </font>
            </h1>
            <a href="login.jsp">Click here to try again</a>
        </div>
        <%@include file="footer.jsp" %>
    </body>
</html>
