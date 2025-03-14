<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Date"%>
<%@page import="dto.BookingDTO"%>
<%@page import="dto.RoomDTO"%>
<%@page import="dto.UserDTO"%>
<%@page import="dao.BookingDAO"%>
<%
    List<BookingDTO> bookingList = (List<BookingDTO>) request.getAttribute("bookingList");
    String errorMessage = (String) request.getAttribute("errorMessage");
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    Date currentDate = new Date();
    UserDTO user = (UserDTO) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Danh sách đặt phòng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
                overflow-x: hidden;
            }
            .main-content {
                padding: 40px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .container {
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
            h2 {
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
            .error-message {
                color: #e74c3c;
                background: #ffebee;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 500;
            }
            .no-booking {
                text-align: center;
                padding: 30px;
                color: #7f8c8d;
                font-size: 18px;
                background: #f9fbfc;
                border-radius: 15px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            }
            .booking-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                table-layout: fixed;
            }
            .booking-table th, .booking-table td {
                padding: 18px;
                text-align: center;
                border-bottom: 1px solid #eee;
                word-wrap: break-word;
            }
            .booking-table th {
                background: linear-gradient(45deg, #1abc9c, #16a085);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                width: 16.67%;
            }
            .booking-table tr:hover {
                background: #f5f7fa;
                transition: background 0.3s ease;
            }
            .booking-table .price {
                font-weight: 600;
                color: #1abc9c;
            }
            .booking-table .status {
                font-weight: 500;
            }
            .booking-table .status.cancelled {
                color: #e74c3c;
            }
            .booking-table .status.success {
                color: #27ae60;
            }
            .booking-table .status.completed {
                color: #7f8c8d;
            }
            .booking-table .status.pending {
                color: #f1c40f;
            }
            .booking-table .actions {
                display: flex;
                justify-content: center;
                gap: 10px;
            }
            .btn {
                padding: 10px 18px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                color: white;
                transition: transform 0.3s ease, background 0.3s ease;
            }
            .btn.cancel {
                background: #e74c3c;
            }
            .btn.cancel:hover {
                background: #c0392b;
                transform: scale(1.05);
            }
            .btn.view {
                background: #3498db;
            }
            .btn.view:hover {
                background: #2980b9;
                transform: scale(1.05);
            }
            .btn.pay {
                background: #f1c40f;
                color: #fff;
            }
            .btn.pay:hover {
                background: #d4ac0d;
                transform: scale(1.05);
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 20px 15px;
                }
                h2 {
                    font-size: 32px;
                }
                .booking-table th, .booking-table td {
                    padding: 12px;
                    font-size: 14px;
                }
                .btn {
                    padding: 8px 12px;
                    font-size: 14px;
                }
                .booking-table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                th {
                    width: auto;
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
        <div class="main-content">
            <div class="container">
                <h2>Danh sách đặt phòng của bạn</h2>
                <a href="<%= request.getContextPath()%>/home.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>

                <% if (errorMessage != null) {%>
                <p class="error-message"><%= errorMessage%></p>
                <% } %>

                <% if (bookingList == null || bookingList.isEmpty()) { %>
                <p class="no-booking">Bạn chưa có đặt phòng nào.</p>
                <% } else { %>
                <table class="booking-table">
                    <thead>
                        <tr>
                            <th>Tên phòng</th>
                            <th>Ngày nhận</th>
                            <th>Ngày trả</th>
                            <th>Giá</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (BookingDTO booking : bookingList) {
                                RoomDTO room = booking.getRoom();
                                String statusClass = "";
                                String displayStatus = "";

                                if (BookingDAO.STATUS_CANCELLED.equals(booking.getStatus())) {
                                    statusClass = "cancelled";
                                    displayStatus = "Đã hủy";
                                } else if (BookingDAO.STATUS_PAID.equals(booking.getStatus()) || BookingDAO.STATUS_CONFIRMED.equals(booking.getStatus())) {
                                    statusClass = "success";
                                    displayStatus = "Đã thanh toán"; // Gộp Paid và Confirmed thành "Đã thanh toán"
                                } else if (BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus())) {
                                    statusClass = "pending";
                                    displayStatus = "Chờ thanh toán";
                                } else if (currentDate.after(booking.getCheckOutDate())) {
                                    statusClass = "completed";
                                    displayStatus = "Đã ở";
                                }
                        %>
                        <tr>
                            <td><%= room != null ? room.getName() : "Không xác định"%></td>
                            <td><%= sdf.format(booking.getCheckInDate())%></td>
                            <td><%= sdf.format(booking.getCheckOutDate())%></td>
                            <td class="price"><%= String.format("%,.0f", booking.getTotalPrice())%> VND</td>
                            <td class="status <%= statusClass%>"><%= displayStatus%></td>
                            <td class="actions">
                                <% if (BookingDAO.STATUS_PENDING_PAYMENT.equals(booking.getStatus()) && currentDate.before(booking.getCheckOutDate())) {%>
                                <!-- Nút Thanh toán -->
                                <form id="paymentForm_<%= booking.getId()%>" action="<%= request.getContextPath()%>/processPayment" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <input type="hidden" name="amount" value="<%= booking.getTotalPrice()%>">
                                    <button type="submit" class="btn pay"><i class="fas fa-credit-card"></i> Thanh toán</button>
                                </form>
                                <!-- Nút Hủy -->
                                <form id="cancelForm_<%= booking.getId()%>" action="<%= request.getContextPath()%>/cancelBooking" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <button type="button" class="btn cancel" onclick="confirmCancel('<%= booking.getId()%>')"><i class="fas fa-times"></i> Hủy</button>
                                </form>
                                <% } %>
                                <!-- Nút Xem -->
                                <% if (room != null) {%>
                                <form action="<%= request.getContextPath()%>/room-details" method="get" style="display:inline;">
                                    <input type="hidden" name="roomId" value="<%= room.getId()%>">
                                    <button type="submit" class="btn view"><i class="fas fa-eye"></i> Xem</button>
                                </form>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                <% }%>
            </div>
        </div>
    </body>
</html>