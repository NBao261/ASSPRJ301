<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.BookingDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="dao.BookingDAO"%> <!-- Thêm để sử dụng hằng số trạng thái -->
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý đặt phòng - Admin</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
            }
            body {
                background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
                color: #2c3e50;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
            }
            .main-content {
                flex: 1;
                padding: 100px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .bookings-container {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                padding: 40px;
                animation: fadeIn 0.5s ease-in;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            h1 {
                font-size: 42px;
                font-weight: 700;
                color: #1a3c34;
                margin-bottom: 30px;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                color: #1abc9c;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 25px;
                transition: color 0.3s ease, transform 0.3s ease;
            }
            .back-link:hover {
                color: #16a085;
                transform: translateX(-5px);
            }
            .back-link i {
                margin-right: 8px;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            }
            th, td {
                padding: 18px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            th {
                background: linear-gradient(45deg, #1abc9c, #16a085);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
            }
            tr:hover {
                background: #f5f7fa;
                transition: background 0.3s ease;
            }
            .status {
                font-weight: 500;
            }
            .status.pending {
                color: #f1c40f; /* Chờ thanh toán */
            }
            .status.paid {
                color: #27ae60; /* Đã thanh toán */
            }
            .status.confirmed {
                color: #3498db; /* Đã xác nhận */
            }
            .status.cancelled {
                color: #e74c3c; /* Đã hủy */
            }
            .btn {
                padding: 10px 18px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                color: white;
                transition: transform 0.3s ease, background 0.3s ease;
                margin-right: 8px;
            }
            .btn-confirm {
                background: #27ae60;
            }
            .btn-confirm:hover {
                background: #219653;
                transform: scale(1.05);
            }
            .btn-cancel {
                background: #e67e22;
            }
            .btn-cancel:hover {
                background: #d35400;
                transform: scale(1.05);
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
                transform: scale(1.05);
            }
            .message {
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 500;
            }
            .message.success {
                background: #e8f5e9;
                color: #27ae60;
            }
            .message.error {
                background: #ffebee;
                color: #e74c3c;
            }
            .no-data {
                text-align: center;
                padding: 30px;
                color: #7f8c8d;
                font-size: 18px;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px;
                }
                h1 {
                    font-size: 32px;
                }
                th, td {
                    padding: 12px;
                    font-size: 14px;
                }
                .btn {
                    padding: 8px 12px;
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
                <a href="<%= request.getContextPath()%>/admin/dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại Dashboard</a>

                <%
                    String successMessage = (String) request.getAttribute("successMessage");
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (successMessage != null) {
                %>
                <div class="message success"><%= successMessage%></div>
                <% } else if (errorMessage != null) {%>
                <div class="message error"><%= errorMessage%></div>
                <% } %>

                <%
                    List<BookingDTO> bookingList = (List<BookingDTO>) request.getAttribute("bookingList");
                    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    if (bookingList == null || bookingList.isEmpty()) {
                %>
                <p class="no-data">Không có đặt phòng nào trong hệ thống.</p>
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
                        <% for (BookingDTO booking : bookingList) {
                                String statusClass = "";
                                String displayStatus = "";
                                if (BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus())) {
                                    statusClass = "pending";
                                    displayStatus = "Chờ thanh toán";
                                } else if (BookingDAO.STATUS_PAID.equals(booking.getStatus())) {
                                    statusClass = "paid";
                                    displayStatus = "Đã thanh toán";
                                } else if (BookingDAO.STATUS_CONFIRMED.equals(booking.getStatus())) {
                                    statusClass = "confirmed";
                                    displayStatus = "Đã xác nhận";
                                } else if (BookingDAO.STATUS_CANCELLED.equals(booking.getStatus())) {
                                    statusClass = "cancelled";
                                    displayStatus = "Đã hủy";
                                }
                        %>
                        <tr>
                            <td><%= booking.getId()%></td>
                            <td><%= booking.getUser() != null ? booking.getUser().getFullName() : "Không xác định"%></td>
                            <td><%= booking.getRoom() != null ? booking.getRoom().getName() : "Không xác định"%></td>
                            <td><%= dateFormat.format(booking.getCheckInDate())%></td>
                            <td><%= dateFormat.format(booking.getCheckOutDate())%></td>
                            <td><%= String.format("%,.0f", booking.getTotalPrice())%></td>
                            <td class="status <%= statusClass%>"><%= displayStatus%></td>
                            <td><%= dateFormat.format(booking.getCreatedAt())%></td>
                            <td>
                                <% if (BookingDAO.STATUS_PAID.equals(booking.getStatus())) {%>
                                <button class="btn btn-confirm" onclick="confirmBooking('<%= booking.getId()%>')"><i class="fas fa-check"></i> Xác nhận</button>
                                <% } %>
                                <% if (!BookingDAO.STATUS_CANCELLED.equals(booking.getStatus())) {%>
                                <button class="btn btn-cancel" onclick="cancelBooking('<%= booking.getId()%>')"><i class="fas fa-times"></i> Hủy</button>
                                <% }%>
                                <button class="btn btn-delete" onclick="deleteBooking('<%= booking.getId()%>')"><i class="fas fa-trash"></i> Xóa</button>
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
                    window.location.href = '<%= request.getContextPath()%>/admin/bookings?action=confirm&bookingId=' + bookingId;
                }
            }

            function cancelBooking(bookingId) {
                if (confirm("Bạn có chắc chắn muốn hủy đặt phòng này không?")) {
                    window.location.href = '<%= request.getContextPath()%>/admin/bookings?action=cancel&bookingId=' + bookingId;
                }
            }

            function deleteBooking(bookingId) {
                if (confirm("Bạn có chắc chắn muốn xóa đặt phòng này không?")) {
                    window.location.href = '<%= request.getContextPath()%>/admin/bookings?action=delete&bookingId=' + bookingId;
                }
            }
        </script>
    </body>
</html>