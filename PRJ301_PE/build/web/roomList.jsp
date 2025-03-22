<%-- 
    Document   : admin
    Created on : Aug 7, 2024, 11:40:23 AM
    Author     : hoadnt
--%>


<%@page import="java.util.List"%>
<%@page import="dto.RoomDTO"%>
<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Room List Page</title>
    </head>
    <body>
        <%
            UserDTO user = (UserDTO) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <h1> Welcome <%= user.getFullName()%> </h1> <br>

        <form action="MainController" method="GET">
            <input type="hidden" name="action" value="logout"/>
            <button type="submit" >logout</button>               
        </form>
        <br>

        <form action="MainController" method="GET">
            <input type="hidden" name="action" value="search"/>
            Search Room <input type="text" name="searchName" value="<%= session.getAttribute("searchTerm") != null ? session.getAttribute("searchTerm") : ""%>"><br>
            <input type="submit" value="Search"/> <br>
        </form>

        <table border = "1">
            <tr>
                <th>Id</th>
                <th>Name</th>
                <th>Description</th>
                <th>price</th>
                <th>area</th>
                <th>Actions</th>
            </tr>
            <%
                List<RoomDTO> rooms = (List<RoomDTO>) request.getAttribute("rooms");
                if (rooms != null && !rooms.isEmpty()) {
                    for (RoomDTO room : rooms) {
            %>
            <tr>
                <td><%= room.getId()%></td>
                <td><%= room.getName()%></td>
                <td><%= room.getDescription()%></td>
                <td><%= room.getPrice()%></td>
                <td><%= room.getArea()%></td>
                <td> 
                    <form action="MainController" method="GET">
                        <input type="hidden" name="action" value="edit"/>
                        <input type="hidden" name="roomID" value="<%= room.getId() %>"/>
                        <input type="submit" value="Update"/>
                    </form>
                </td>
            </tr>
            <% }
            } else {
            %>
            <tr>
                <td colspan="4" style="text-align: center;">No results found.</td>
            </tr>
            <%
                }
            %>
        </table>
    </body>
</html>
