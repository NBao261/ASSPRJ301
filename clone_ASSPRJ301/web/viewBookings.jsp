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
<html lang="vi">
    <head>
        <title>Danh sách đặt phòng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                margin: 0;
                padding-top: 70px;
                display: flex;
                flex-direction: column;
                min-height: 100vh;
                align-items: center;
            }

            .container {
                width: 90%;
                max-width: 1000px;
                padding: 20px;
                background-color: #fff;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
                flex: 1;
                text-align: center;
            }

            .header-container, .footer-container {
                width: 100%;
                background-color: #fff;
                text-align: center;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                padding: 10px 0;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            table th, table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            table th {
                background-color: #007bff;
                color: #fff;
            }

            table tr:hover {
                background-color: #f1f1f1;
            }

            .btn {
                padding: 8px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: background-color 0.3s;
            }

            .btn.cancel { background-color: #dc3545; color: #fff; }
            .btn.cancel:hover { background-color: #c82333; }
            .btn.update { background-color: #28a745; color: #fff; }
            .btn.update:hover { background-color: #218838; }

            .back-link {
                display: inline-block;
                margin-bottom: 20px;
                color: #007bff;
                text-decoration: none;
                font-size: 16px;
            }
            .back-link:hover {
                text-decoration: underline;
            }

            .error-message {
                color: red;
                font-weight: bold;
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
        <div class="header-container">
            <%@include file="header.jsp"%>
        </div>
        
        <div class="container">
            <h2>Danh sách đặt phòng của bạn</h2>
            <a href="home.jsp" class="back-link">← Quay lại trang chủ</a>
            
            <% if (errorMessage != null) { %>
            <p class="error-message"><%= errorMessage %></p>
            <% } %>

            <% if (bookingList == null || bookingList.isEmpty()) { %>
                <p class="no-booking">Bạn chưa có đặt phòng nào.</p>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Phòng</th>
                        <th>Ngày nhận</th>
                        <th>Ngày trả</th>
                        <th>Giá</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BookingDTO booking : bookingList) {
                        RoomDTO room = booking.getRoom(); %>
                    <tr>
                        <td><%= room.getName() %></td>
                        <td><%= sdf.format(booking.getCheckInDate()) %></td>
                        <td><%= sdf.format(booking.getCheckOutDate()) %></td>
                        <td><%= String.format("%,.0f", booking.getTotalPrice()) %> VND</td>
                        <td><%= booking.getStatus() %></td>
                        <td>
                            <% if (!"Cancelled".equals(booking.getStatus())) { %>
                            <form id="cancelForm_<%= booking.getId() %>" action="cancelBooking" method="post" style="display:inline;">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <button type="button" class="btn cancel" onclick="confirmCancel('<%= booking.getId() %>')">Hủy</button>
                            </form>
                            <% } %>
                            <form action="updateBooking.jsp" method="get" style="display:inline;">
                                <input type="hidden" name="bookingId" value="<%= booking.getId() %>">
                                <button type="submit" class="btn update">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } %>
        </div>
        
        <div class="footer-container">
            <%@include file="footer.jsp"%>
        </div>
    </body>
</html>