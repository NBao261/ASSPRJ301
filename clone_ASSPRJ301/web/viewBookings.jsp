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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0; /* Ensure no default margins */
        }

        .header-container, .footer-container {
            width: 100%;
            background: #ffffff;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.05);
            position: fixed;
            z-index: 1000; /* Ensure header stays on top */
        }

        .header-container {
            top: 0;
            height: 60px; /* Set a fixed height for consistency */
        }

        .footer-container {
            bottom: 0;
            height: 60px; /* Set a fixed height for consistency */
        }

        .main-content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 80px 0; /* Adjusted padding to account for header and footer height */
            overflow: auto; /* Ensure content scrolls if too long */
        }

        .container {
            max-width: 1200px;
            width: 95%;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }

        h2 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 25px;
            text-align: center;
            font-size: 2rem;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #2980b9;
        }

        .back-link::before {
            content: '←';
            margin-right: 5px;
        }

        .error-message {
            color: #e74c3c;
            background: #ffebee;
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .no-booking {
            text-align: center;
            color: #7f8c8d;
            font-size: 1.1rem;
            padding: 20px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 20px;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        th {
            background: #3498db;
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        tr {
            transition: background 0.3s ease;
        }

        tr:hover {
            background: #f8fafc;
        }

        td {
            border-bottom: 1px solid #ecf0f1;
            color: #2c3e50;
        }

        .btn {
            padding: 8px 20px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }

        .btn.cancel {
            background: #e74c3c;
            color: white;
        }

        .btn.cancel:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }

        .btn.update {
            background: #2ecc71;
            color: white;
        }

        .btn.update:hover {
            background: #27ae60;
            transform: translateY(-2px);
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            th, td {
                padding: 10px;
                font-size: 0.9rem;
            }

            .btn {
                padding: 6px 15px;
                font-size: 0.75rem;
            }

            .main-content {
                padding: 60px 0;
            }

            .header-container, .footer-container {
                height: 50px; /* Adjust height for smaller screens */
            }
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

    <div class="main-content">
        <div class="container">
            <h2>Danh sách đặt phòng của bạn</h2>
            <a href="home.jsp" class="back-link">Quay lại trang chủ</a>

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
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp"%>
    </div>
</body>
</html>