<%-- 
    Document   : editRoom
    Created on : Mar 19, 2025, 3:54:21 PM
    Author     : cbao
--%>

<%@page import="dto.RoomDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            RoomDTO room = (RoomDTO) request.getAttribute("room");
        %>
        <h1>Edit Room Information</h1>
        <form action="MainController" method="POST">
            <input type="hidden" name="action" value="update"/>
            <input type="hidden" name="roomID" value="<%= room.getId()%>"/>
            Name: <input type="text" name="name" value="<%= room.getName()%>"/> <br>
            Description: <input type="text" name="description" value="<%= room.getDescription()%>"/> <br>
            Price: <input type="text" name="price" value="<%= room.getPrice()%>"/> <br>
            Area: <input type="text" name="area" value="<%= room.getArea()%>"/> <br>

            <input type="submit" value="Save"/>
        </form>
    </body>
</html>
