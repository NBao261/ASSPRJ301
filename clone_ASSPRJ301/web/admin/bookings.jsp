<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.BookingDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý đặt phòng - Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-content {
            flex: 1;
            padding: 80px 0;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }

        .bookings-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .bookings-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h1 {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #2980b9;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            font-weight: 600;
        }

        tr:hover {
            background: #f8f9fa;
        }

        .btn {
            padding: 8px 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.3s ease, background 0.3s ease;
            margin-right: 5px;
        }

        .btn-confirm {
            background: #2ecc71;
            color: white;
        }

        .btn-confirm:hover {
            background: #27ae60;
            transform: scale(1.05);
        }

        .btn-cancel {
            background: #e67e22;
            color: white;
        }

        .btn-cancel:hover {
            background: #d35400;
            transform: scale(1.05);
        }

        .btn-delete {
            background: #e74c3c;
            color: white;
        }

        .btn-delete:hover {
            background: #c0392b;
            transform: scale(1.05);
        }

        .message {
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
        }

        .message.success {
            background: #e8f5e9;
            color: #27ae60;
        }

        .message.error {
            background: #ffebee;
            color: #e74c3c;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 15px;
            }

            h1 {
                font-size: 28px;
            }

            th, td {
                padding: 10px;
                font-size: 14px;
            }

            .btn {
                padding: 6px 12px;
                font-size: 14px;
            }

            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
        }
    </style>
</head>
<body>
    <div class="header-container">
        <%@include file="../header.jsp" %>
    </div>

    <div class="main-content">
        <div class="bookings-container">
            <h1>Quản lý đặt phòng</h1>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="back-link">← Quay lại Dashboard</a>

            <% 
                String successMessage = (String) request.getAttribute("successMessage");
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (successMessage != null) { 
            %>
                <div class="message success"><%= successMessage %></div>
            <% } else if (errorMessage != null) { %>
                <div class="message error"><%= errorMessage %></div>
            <% } %>

            <%
                List<BookingDTO> bookingList = (List<BookingDTO>) request.getAttribute("bookingList");
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                if (bookingList == null || bookingList.isEmpty()) {
            %>
            <p>Không có đặt phòng nào trong hệ thống.</p>
            <%
                } else {
            %>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Tên Người dùng</th>
                        <th>Tên Phòng</th>
                        <th>Ngày nhận phòng</th>
                        <th>Ngày trả phòng</th>
                        <th>Tổng tiền (VND)</th>
                        <th>Trạng thái</th>
                        <th>Ngày tạo</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BookingDTO booking : bookingList) { %>
                    <tr>
                        <td><%= booking.getId() %></td>
                        <td><%= booking.getUser() != null ? booking.getUser().getFullName() : "Không xác định" %></td>
                        <td><%= booking.getRoom() != null ? booking.getRoom().getName() : "Không xác định" %></td>
                        <td><%= dateFormat.format(booking.getCheckInDate()) %></td>
                        <td><%= dateFormat.format(booking.getCheckOutDate()) %></td>
                        <td><%= String.format("%,.0f", booking.getTotalPrice()) %></td>
                        <td><%= booking.getStatus() %></td>
                        <td><%= dateFormat.format(booking.getCreatedAt()) %></td>
                        <td>
                            <% if (!"Cancelled".equals(booking.getStatus()) && !"Confirmed".equals(booking.getStatus())) { %>
                            <button class="btn btn-confirm" onclick="confirmBooking('<%= booking.getId() %>')">Xác nhận</button>
                            <% } %>
                            <% if (!"Cancelled".equals(booking.getStatus())) { %>
                            <button class="btn btn-cancel" onclick="cancelBooking('<%= booking.getId() %>')">Hủy</button>
                            <% } %>
                            <button class="btn btn-delete" onclick="deleteBooking('<%= booking.getId() %>')">Xóa</button>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <%
                }
            %>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="../footer.jsp" %>
    </div>

    <script>
        function confirmBooking(bookingId) {
            if (confirm("Bạn có chắc chắn muốn xác nhận đặt phòng này không?")) {
                window.location.href = '<%= request.getContextPath() %>/admin/bookings?action=confirm&bookingId=' + bookingId;
            }
        }

        function cancelBooking(bookingId) {
            if (confirm("Bạn có chắc chắn muốn hủy đặt phòng này không?")) {
                window.location.href = '<%= request.getContextPath() %>/admin/bookings?action=cancel&bookingId=' + bookingId;
            }
        }

        function deleteBooking(bookingId) {
            if (confirm("Bạn có chắc chắn muốn xóa đặt phòng này không?")) {
                window.location.href = '<%= request.getContextPath() %>/admin/bookings?action=delete&bookingId=' + bookingId;
            }
        }
    </script>
</body>
</html>