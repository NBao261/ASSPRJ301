<%-- 
    Document   : login
    Created on : Aug 7, 2024, 11:04:18 AM
    Author     : hoadnt
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <h1>Login Information</h1>

        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="login"/>
            UserID <input type="text" name="txtUserID"/>
            Password <input type="password" name="txtPassword"/>
            <input type="submit" value="Login"/>
        </form>
        <% if (request.getAttribute("error") != null) {%>
        <p style="color:red"><%= request.getAttribute("error")%></p>
        <% }%>
    </body>
</html>
