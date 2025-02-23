<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="dto.BookingDTO"%>
<%@page import="dto.RoomDTO"%>
<%
    List<BookingDTO> bookingList = (List<BookingDTO>) request.getAttribute("bookingList");
    String errorMessage = (String) request.getAttribute("errorMessage");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <link rel="stylesheet" type="text/css" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #f8f8f8;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .actions {
            display: flex;
            gap: 10px;
        }
        .actions input[type="submit"] {
            padding: 5px 10px;
            border: none;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            border-radius: 3px;
        }
        .actions input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-bottom: 20px;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        function confirmCancel(bookingId) {
            if (confirm("Bạn có chắc chắn muốn hủy đặt phòng này không?")) {
                document.getElementById('cancelForm_' + bookingId).submit();
            }
        }
    </script>
</head>
<body>
    <%@include file="header.jsp"%>
    
    <div class="container">
        <h2>Danh sách đặt phòng của bạn</h2>
        
        <% if (errorMessage != null) { %>
            <p class="error-message"><%= errorMessage %></p>
        <% } %>
        
        <% if (bookingList == null || bookingList.isEmpty()) { %>
            <p>Bạn chưa có đặt phòng nào.</p>
        <% } else { %>
            <table>
                <tr>
                    <th>Phòng</th>
                    <th>Ngày nhận</th>
                    <th>Ngày trả</th>
                    <th>Giá</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                <% for (BookingDTO booking : bookingList) { 
                    RoomDTO room = booking.getRoom();
                %>
                <tr>
                    <td><%= room.getName() %></td>
                    <td><%= sdf.format(booking.getCheckInDate()) %></td>
                    <td><%= sdf.format(booking.getCheckOutDate()) %></td>
                    <td><%= String.format("%,.0f", booking.getTotalPrice()) %> VND</td>
                    <td><%= booking.getStatus() %></td>
                    <td class="actions">
                        <% if (!"Cancelled".equals(booking.getStatus())) { %>
                            <form id="cancelForm_<%= booking.getId() %>" action="cancelBooking" method="post" style="display:inline;">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <input type="button" value="Hủy đặt phòng" onclick="confirmCancel('<%= booking.getId() %>')">
                            </form>
                        <% } %>
                        <form action="updateBooking.jsp" method="get" style="display:inline;">
                            <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                            <input type="submit" value="Cập nhật">
                        </form>
                    </td>
                </tr>
                <% } %>
            </table>
        <% } %>
        
        <br>
        <a href="home.jsp" class="back-link">Quay lại trang chủ</a>
    </div>
    
    <%@include file="footer.jsp"%>
</body>
</html>