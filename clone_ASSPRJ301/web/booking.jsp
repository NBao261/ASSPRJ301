<%@page import="dto.RoomDTO, dao.RoomDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // Lấy roomId từ request
    String roomIdParam = request.getParameter("roomId");
    RoomDAO roomDAO = new RoomDAO();
    RoomDTO room = null;

    if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
        int roomId = Integer.parseInt(roomIdParam);
        room = roomDAO.getRoomById(roomId);  // Sử dụng getRoomById thay vì getRoomByName
    }

    // Lấy thông báo thành công hoặc lỗi từ request
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<%@include file="header.jsp" %>

<body>
<%
    if (room == null) {
%>
    <h2 style="text-align:center; margin-top:50px;">Không tìm thấy thông tin phòng!</h2>
    <div style="text-align:center;">
        <a href="home.jsp" class="btn-back">Quay lại trang chủ</a>
    </div>
<%
    } else {
%>
    <div class="booking-container">
        <div class="room-image">
            <img src="<%= room.getImageUrl() %>" alt="<%= room.getName() %>">
        </div>

        <div class="booking-details">
            <h2>Đặt phòng: <%= room.getName() %></h2>
            <p><strong>Mô tả:</strong> <%= room.getDescription() %></p>
            <p><strong>Giá:</strong> <span id="room-price"><%= room.getPrice() %></span> đ / đêm</p>
            <p><strong>Tiện nghi:</strong> <%= room.getAmenities() %></p>
            <p><strong>Đánh giá:</strong> <%= room.getRatings() %> ⭐</p>

            <!-- Hiển thị thông báo lỗi hoặc thành công -->
            <% if (errorMessage != null) { %>
                <p style="color: red;"><%= errorMessage %></p>
            <% } %>
            <% if (successMessage != null) { %>
                <p style="color: green;"><%= successMessage %></p>
            <% } %>

            <form action="bookRoom" method="post" onsubmit="return validateForm()">
                <input type="hidden" name="roomId" value="<%= room.getId() %>"> <!-- Sử dụng roomId thay vì roomName -->
                
                <label for="checkInDate">Ngày nhận phòng:</label>
                <input type="date" id="checkInDate" name="checkInDate" required onchange="calculateTotal()">

                <label for="checkOutDate">Ngày trả phòng:</label>
                <input type="date" id="checkOutDate" name="checkOutDate" required onchange="calculateTotal()">

                <p><strong>Tổng tiền:</strong> <span id="total-price">0</span> đ</p>
                <button type="submit" class="btn-book">Xác nhận đặt phòng</button>
            </form>
        </div>
    </div>

    <script>
        function validateForm() {
            let checkIn = new Date(document.getElementById("checkInDate").value);
            let checkOut = new Date(document.getElementById("checkOutDate").value);
            let today = new Date();
            
            if (checkIn < today) {
                alert("Ngày nhận phòng phải từ hôm nay trở đi.");
                return false;
            }
            if (checkOut <= checkIn) {
                alert("Ngày trả phòng phải sau ngày nhận phòng.");
                return false;
            }
            return true;
        }

        function calculateTotal() {
            let pricePerNight = <%= room.getPrice() %>;
            let checkIn = new Date(document.getElementById("checkInDate").value);
            let checkOut = new Date(document.getElementById("checkOutDate").value);
            
            if (!isNaN(checkIn.getTime()) && !isNaN(checkOut.getTime()) && checkOut > checkIn) {
                let nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
                let totalPrice = pricePerNight * nights;
                document.getElementById("total-price").innerText = totalPrice.toLocaleString();
            } else {
                document.getElementById("total-price").innerText = "0";
            }
        }
    </script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f8f8f8;
            margin: 0;
            padding: 0;
        }
        .booking-container {
            max-width: 800px;
            margin: 50px auto;
            display: flex;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        .room-image {
            flex: 1;
            padding-right: 20px;
        }
        .room-image img {
            width: 100%;
            border-radius: 10px;
        }
        .booking-details {
            flex: 1;
        }
        .btn-book {
            display: inline-block;
            background: #ff6600;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            text-align: center;
            font-weight: bold;
            border: none;
            cursor: pointer;
        }
        .btn-book:hover {
            background: #cc5200;
        }
        input {
            width: 100%;
            padding: 8px;
            margin: 5px 0 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
    </style>

<%
    }
%>

</body>

<%@include file="footer.jsp" %>