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
            /* Reset CSS */
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
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 80px 0 80px;
                overflow: auto;
                max-width: 1200px;
                margin: 0 auto;
                width: 90%;
            }

            .container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                padding: 30px;
                width: 100%;
                max-width: 1000px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .container:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
            }

            h2 {
                color: #2c3e50;
                font-weight: 700;
                margin-bottom: 25px;
                text-align: center;
                font-size: 2.5rem;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
            }

            .back-link {
                display: inline-flex;
                align-items: center;
                color: #3498db;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 20px;
                transition: color 0.3s ease, transform 0.3s ease;
            }

            .back-link:hover {
                color: #2980b9;
                transform: translateX(-2px);
            }

            .back-link::before {
                content: '←';
                margin-right: 5px;
                font-size: 1.1rem;
            }

            .error-message {
                color: #e74c3c;
                background: #ffebee;
                padding: 12px 18px;
                border-radius: 10px;
                margin-bottom: 20px;
                text-align: center;
                font-weight: 500;
                box-shadow: 0 2px 8px rgba(231, 76, 60, 0.1);
            }

            .no-booking {
                text-align: center;
                color: #7f8c8d;
                font-size: 1.2rem;
                padding: 25px;
                background: #f8fafc;
                border-radius: 10px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            }

            /* Table Styles */
            .booking-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            }

            .booking-table th, .booking-table td {
                padding: 15px;
                text-align: left;
                font-size: 16px;
                color: #555;
            }

            .booking-table th {
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .booking-table tr {
                border-bottom: 1px solid #eee;
                transition: background 0.3s ease;
            }

            .booking-table tr:hover {
                background: #f8fafc;
            }

            .booking-table .price {
                font-weight: 600;
                color: #5DC1B9;
            }

            .booking-table .status {
                font-weight: 500;
            }

            .booking-table .status.cancelled {
                color: #e74c3c;
            }

            .booking-table .actions {
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 8px 18px;
                border: none;
                border-radius: 20px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                font-size: 0.9rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
            }

            .btn.update:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                transform: translateY(-2px);
            }

            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px 70px;
                }

                .container {
                    padding: 20px;
                }

                h2 {
                    font-size: 2rem;
                }

                .booking-table th, .booking-table td {
                    font-size: 14px;
                    padding: 10px;
                }

                .booking-table {
                    display: block;
                    overflow-x: auto; /* Enable horizontal scrolling on mobile */
                    white-space: nowrap;
                }

                .btn {
                    padding: 6px 14px;
                    font-size: 0.8rem;
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
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </head>
    <body>
        <div class="main-content">
            <div class="container">
                <h2>Danh sách đặt phòng của bạn</h2>
                <a href="home.jsp" class="back-link">Quay lại trang chủ</a>

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
                                RoomDTO room = booking.getRoom();%>
                        <tr>
                            <td><%= room.getName()%></td>
                            <td><%= sdf.format(booking.getCheckInDate())%></td>
                            <td><%= sdf.format(booking.getCheckOutDate())%></td>
                            <td class="price"><%= String.format("%,.0f", booking.getTotalPrice())%> VND</td>
                            <td class="status <%= "Cancelled".equals(booking.getStatus()) ? "cancelled" : ""%>">
                                <%= booking.getStatus()%>
                            </td>
                            <td class="actions">
                                <% if (!"Cancelled".equals(booking.getStatus())) {%>
                                <form id="cancelForm_<%= booking.getId()%>" action="cancelBooking" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <button type="button" class="btn cancel" onclick="confirmCancel('<%= booking.getId()%>')">Hủy</button>
                                </form>
                                <% }%>
                                <form action="updateBooking.jsp" method="get" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getId()%>">
                                    <button type="submit" class="btn update">Cập nhật</button>
                                </form>
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