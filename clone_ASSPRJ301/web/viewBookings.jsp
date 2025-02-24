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
            font-family: 'Segoe UI', Arial, sans-serif; /* Match header/footer font */
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); /* Subtle gradient for modern look */
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header and Footer Containers (handled by included files) */
        .header-container, .footer-container {
            width: 100%;
            z-index: 1000;
        }

/*        .header-container {
            position: fixed;
            top: 0;
            left: 0;
            height: 60px;  Match header.jsp height for desktop 
        }

        .footer-container {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;  Ensure full width 
            height: 80px;  Match footer.jsp height for desktop 
            z-index: 999;
        }*/

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center; /* Center vertically between header and footer */
            align-items: center; /* Center horizontally */
            padding: 80px 0 80px; /* Space for fixed header (60px) and footer (80px) */
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 1000px; /* Limit container width for better centering on large screens */
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
            transition: transform 0.3s ease;
        }

        .error-message:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.2);
        }

        .no-booking {
            text-align: center;
            color: #7f8c8d;
            font-size: 1.2rem;
            padding: 25px;
            background: #f8fafc;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
        }

        .no-booking:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* Booking List Cards */
        .booking-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
            width: 100%; /* Ensure full width within container */
        }

        .booking-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .booking-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }

        .booking-card h3 {
            font-size: 1.5rem;
            color: #2c3e50;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .booking-card p {
            font-size: 16px;
            color: #555;
            margin-bottom: 10px;
            line-height: 1.6;
        }

        .booking-card .price {
            font-size: 18px;
            font-weight: 600;
            color: #5DC1B9; /* Match header/footer color */
            margin-bottom: 15px;
        }

        .booking-card .status {
            font-size: 16px;
            font-weight: 500;
            color: #27ae60;
            margin-bottom: 15px;
        }

        .booking-card .status.cancelled {
            color: #e74c3c;
        }

        .booking-card .actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .btn {
            padding: 10px 22px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .btn.cancel {
            background: #e74c3c;
            color: white;
        }

        .btn.cancel:hover {
            background: #c0392b;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(231, 76, 60, 0.2);
        }

        .btn.update {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4); /* Match header/footer gradient */
            color: white;
        }

        .btn.update:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 0 70px; /* Adjust for mobile header (50px) and footer (70px) */
                padding: 0 15px; /* Add horizontal padding for mobile */
            }

            .container {
                padding: 20px;
                width: 100%;
            }

            h2 {
                font-size: 2rem;
            }

            .back-link {
                font-size: 0.9rem;
            }

            .booking-list {
                grid-template-columns: 1fr; /* Stack cards vertically on mobile */
                gap: 15px;
            }

            .booking-card {
                padding: 15px;
            }

            .booking-card h3 {
                font-size: 1.2rem;
            }

            .booking-card p, .booking-card .price, .booking-card .status {
                font-size: 14px;
            }

            .btn {
                padding: 8px 18px;
                font-size: 0.8rem;
            }

            .error-message, .no-booking {
                padding: 10px 15px;
                font-size: 0.9rem;
            }

            .header-container {
                height: 50px; /* Match header.jsp height for mobile */
            }

            .footer-container {
                height: 70px; /* Match footer.jsp height for mobile */
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
    <!-- Include FontAwesome for footer.jsp -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>
    <%@include file ="header.jsp" %>

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
                <div class="booking-list">
                    <% for (BookingDTO booking : bookingList) {
                        RoomDTO room = booking.getRoom(); %>
                        <div class="booking-card">
                            <h3><%= room.getName() %></h3>
                            <p><strong>Ngày nhận:</strong> <%= sdf.format(booking.getCheckInDate()) %></p>
                            <p><strong>Ngày trả:</strong> <%= sdf.format(booking.getCheckOutDate()) %></p>
                            <p class="price"><strong>Giá:</strong> <%= String.format("%,.0f", booking.getTotalPrice()) %> VND</p>
                            <p class="status <%= "Cancelled".equals(booking.getStatus()) ? "cancelled" : "" %>">
                                <strong>Trạng thái:</strong> <%= booking.getStatus() %>
                            </p>
                            <div class="actions">
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
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp"%>
    </div>
</body>
</html>