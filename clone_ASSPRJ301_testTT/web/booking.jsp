<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="dto.RoomDTO, dao.RoomDAO"%>
<%@page import="java.util.List"%>

<%
    String roomIdParam = request.getParameter("roomId");
    RoomDAO roomDAO = new RoomDAO();
    RoomDTO room = null;

    if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
        int roomId = Integer.parseInt(roomIdParam);
        room = roomDAO.getRoomById(roomId);
    }

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt phòng - Homestay</title>
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

        .header-container, .footer-container {
            width: 100%;
            z-index: 1000;
        }

        .header-container {
            position: fixed;
            top: 0;
            left: 0;
            height: 60px;
        }

        .footer-container {
            position: relative;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 80px;
            z-index: 999;
        }

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 80px 0 80px;
            overflow: auto;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }

        .booking-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .booking-container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        .room-slideshow {
            position: relative;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .room-slideshow img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 15px;
            display: none;
            transition: opacity 0.5s ease-in-out;
        }

        .room-slideshow img.active {
            display: block;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            padding: 12px 18px;
            cursor: pointer;
            border-radius: 50%;
            font-size: 24px;
            transition: background 0.3s ease, transform 0.3s ease;
        }

        .prev:hover, .next:hover {
            background: rgba(0, 0, 0, 0.9);
            transform: translateY(-50%) scale(1.1);
        }

        .prev { left: 20px; }
        .next { right: 20px; }

        .booking-details {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .booking-details h2 {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .booking-details p {
            font-size: 18px;
            line-height: 1.8;
            color: #555;
            margin-bottom: 10px;
        }

        .booking-details strong {
            color: #5DC1B9;
        }

        .booking-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .booking-form label {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .booking-form input[type="date"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s ease;
            background: #f8f9fa;
        }

        .booking-form input[type="date"]:focus {
            border-color: #5DC1B9;
            outline: none;
        }

        .total-price {
            font-size: 20px;
            font-weight: 600;
            color: #5DC1B9;
            margin-top: 15px;
        }

        .btn-book {
            display: inline-block;
            margin-top: 20px;
            padding: 14px 30px;
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
            border: none;
            cursor: pointer;
            width: 100%;
            text-align: center;
        }

        .btn-book:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
        }

        .btn-book:disabled {
            background: #95a5a6;
            cursor: not-allowed;
            box-shadow: none;
        }

        .message {
            padding: 10px 15px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 16px;
            font-weight: 500;
        }

        .message.error {
            background: #ffebee;
            color: #e74c3c;
            border: 1px solid #e74c3c;
        }

        .message.success {
            background: #e8f5e9;
            color: #27ae60;
            border: 1px solid #27ae60;
        }

        .availability-message {
            padding: 10px 15px;
            border-radius: 8px;
            margin-top: 10px;
            font-size: 16px;
            font-weight: 500;
            text-align: center;
        }

        .availability-message.available {
            background: #e8f5e9;
            color: #27ae60;
            border: 1px solid #27ae60;
        }

        .availability-message.unavailable {
            background: #ffebee;
            color: #e74c3c;
            border: 1px solid #e74c3c;
        }

        .btn-back {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 25px;
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            text-decoration: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
        }

        .btn-back:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: scale(1.05);
            box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 0 70px;
                padding: 0 15px;
            }

            .booking-container {
                margin: 80px auto 20px;
                padding: 20px;
            }

            .room-slideshow img {
                height: 250px;
            }

            .booking-details h2 {
                font-size: 24px;
            }

            .booking-details p {
                font-size: 16px;
            }

            .booking-form label {
                font-size: 14px;
            }

            .booking-form input[type="date"] {
                padding: 10px;
                font-size: 14px;
            }

            .total-price {
                font-size: 18px;
            }

            .btn-book, .btn-back {
                padding: 12px 25px;
                font-size: 16px;
            }

            .message, .availability-message {
                font-size: 14px;
                padding: 8px 12px;
            }

            .footer-container {
                height: 70px;
            }
        }
    </style>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>
    <div class="header-container">
        <%@include file="header.jsp" %>
    </div>

    <div class="main-content">
        <%
            if (room == null) {
        %>
        <div style="text-align: center; margin-top: 50px;">
            <h2 style="font-size: 28px; color: #2c3e50;">Không tìm thấy thông tin phòng!</h2>
            <a href="home.jsp" class="btn-back">Quay lại trang chủ</a>
        </div>
        <%
            } else {
        %>
        <div class="booking-container">
            <div class="room-slideshow">
                <%
                    List<String> detailImages = room.getDetailImages();
                    if (detailImages == null || detailImages.isEmpty()) {
                        detailImages = new java.util.ArrayList<>();
                        detailImages.add(room.getImageUrl());
                    } else if (!detailImages.contains(room.getImageUrl())) {
                        detailImages.add(0, room.getImageUrl());
                    }
                    for (int i = 0; i < detailImages.size(); i++) {
                        String imageUrl = detailImages.get(i);
                        String activeClass = (i == 0) ? "active" : "";
                %>
                <img src="<%= imageUrl %>" alt="<%= room.getName() %>" class="<%= activeClass %>">
                <%
                    }
                %>
                <button class="prev" onclick="changeImage(-1)">❮</button>
                <button class="next" onclick="changeImage(1)">❯</button>
            </div>

            <div class="booking-details">
                <h2>Đặt phòng: <%= room.getName() %></h2>
                <p><strong>Mô tả:</strong> <%= room.getDescription() %></p>
                <p><strong>Giá:</strong> <span id="room-price"><%= room.getPrice() %></span> đ / đêm</p>
                <p><strong>Tiện nghi:</strong> <%= room.getAmenities() %></p>
                <p><strong>Đánh giá:</strong> <%= room.getRatings() %> ⭐</p>

                <% if (errorMessage != null) { %>
                    <div class="message error"><%= errorMessage %></div>
                <% } %>
                <% if (successMessage != null) { %>
                    <div class="message success"><%= successMessage %></div>
                <% } %>
                <div id="availability-message" class="availability-message" style="display: none;"></div>

                <form action="bookRoom" method="post" onsubmit="return validateForm()" class="booking-form">
                    <input type="hidden" name="roomId" value="<%= room.getId() %>">
                    
                    <label for="checkInDate">Ngày nhận phòng:</label>
                    <input type="date" id="checkInDate" name="checkInDate" required onchange="checkAvailability()">

                    <label for="checkOutDate">Ngày trả phòng:</label>
                    <input type="date" id="checkOutDate" name="checkOutDate" required onchange="checkAvailability()">

                    <p class="total-price"><strong>Tổng tiền:</strong> <span id="total-price">0</span> đ</p>
                    <button type="submit" id="bookButton" class="btn-book" disabled>Xác nhận đặt phòng</button>
                </form>
            </div>
        </div>
        <%
            }
        %>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp" %>
    </div>

    <script>
        let currentIndex = 0;
        const images = document.querySelectorAll('.room-slideshow img');

        function showImage(index) {
            images.forEach((img, i) => {
                img.classList.remove('active');
                if (i === index) {
                    img.classList.add('active');
                }
            });
        }

        function changeImage(direction) {
            currentIndex += direction;
            if (currentIndex < 0) {
                currentIndex = images.length - 1;
            } else if (currentIndex >= images.length) {
                currentIndex = 0;
            }
            showImage(currentIndex);
        }

        showImage(currentIndex);

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

        function checkAvailability() {
            let roomId = <%= room != null ? room.getId() : -1 %>;
            let checkInDate = document.getElementById("checkInDate").value;
            let checkOutDate = document.getElementById("checkOutDate").value;
            let bookButton = document.getElementById("bookButton");
            let availabilityMessage = document.getElementById("availability-message");

            calculateTotal(); // Tính tổng tiền khi thay đổi ngày

            if (checkInDate && checkOutDate) { //Kiem tra xem con trong khong va in truc tiep len mh
                let xhr = new XMLHttpRequest();
                xhr.open("GET", "checkAvailability?roomId=" + roomId + "&checkInDate=" + checkInDate + "&checkOutDate=" + checkOutDate, true);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        let response = JSON.parse(xhr.responseText);
                        if (response.available) {
                            availabilityMessage.style.display = "block";
                            availabilityMessage.className = "availability-message available";
                            availabilityMessage.innerText = "Phòng còn trống";
                            bookButton.disabled = false;
                        } else {
                            availabilityMessage.style.display = "block";
                            availabilityMessage.className = "availability-message unavailable";
                            availabilityMessage.innerText = "Phòng đã được đặt";
                            bookButton.disabled = true;
                        }
                    } else if (xhr.readyState === 4) {
                        availabilityMessage.style.display = "block";
                        availabilityMessage.className = "availability-message error";
                        availabilityMessage.innerText = "Lỗi khi kiểm tra trạng thái phòng";
                        bookButton.disabled = true;
                    }
                };
                xhr.send();
            } else {
                availabilityMessage.style.display = "none";
                bookButton.disabled = true;
            }
        }
    </script>
</body>
</html>