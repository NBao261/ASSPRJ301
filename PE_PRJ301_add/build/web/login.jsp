<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login page</title>
    </head>
    <body>
        <h1>Login</h1>
        <hr/>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="login"/>
            Account <input type="text" name="txtAccount"/>
            Pass <input type="password" name="txtPass"/>
            <input type="submit" value="Login"/>
        </form>
        <% if (request.getAttribute("error") != null) {%>
        <p style="color:red"><%= request.getAttribute("error")%></p>
        <% }%>
    </body>
</html>
