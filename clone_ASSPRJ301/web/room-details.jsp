<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dto.RoomDTO" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng</title>
    <style>
        /* RESET CSS */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: #f8f9fa;
            color: #333;
        }

        /* CONTAINER CHI TIẾT PHÒNG */
        .room-details {
            max-width: 1100px;
            margin: 80px auto 50px;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            display: flex;
            gap: 20px;
            align-items: center;
        }

        /* SLIDESHOW ẢNH */
        .room-gallery {
            flex: 1;
            position: relative;
        }

        .room-gallery img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
            transition: opacity 0.5s ease-in-out;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.5);
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 50%;
            font-size: 18px;
        }

        .prev { left: 10px; }
        .next { right: 10px; }

        /* THÔNG TIN CHI TIẾT */
        .room-info {
            flex: 1;
        }

        .room-info h2 {
            font-size: 24px;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .room-info p {
            font-size: 16px;
            margin-bottom: 8px;
        }

        .room-info strong {
            color: #27ae60;
        }

        /* NÚT ĐẶT PHÒNG */
        .btn-book {
            display: inline-block;
            margin-top: 15px;
            padding: 12px 20px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s, transform 0.2s;
        }

        .btn-book:hover {
            background: #ff6b6b;
            transform: scale(1.05);
        }

        /* FOOTER */
        footer {
            text-align: center;
            padding: 15px;
            background: #5DC1B9;
            color: white;
            position: fixed;
            width: 100%;
            bottom: 0;
        }
    </style>
</head>
<body>

<%@include file="header.jsp" %>

<%
    RoomDTO room = (RoomDTO) request.getAttribute("room");
    if (room == null) {
%>
    <h2 style="text-align:center; margin-top:50px;">Không tìm thấy thông tin phòng!</h2>
    <div style="text-align:center;">
        <a href="home.jsp" class="btn-book">Quay lại trang chủ</a>
    </div>
<%
    } else {
%>

<div class="room-details">
    <div class="room-gallery">
        <img id="room-image" src="<%= room.getImageUrl() %>" alt="<%= room.getName() %>">
        <button class="prev" onclick="changeImage(-1)">&#10094;</button>
        <button class="next" onclick="changeImage(1)">&#10095;</button>
    </div>
    
    <div class="room-info">
        <h2><%= room.getName() %></h2>
        <p><%= room.getDescription() %></p>
        <p><strong>Giá:</strong> <%= room.getPrice() %>đ / đêm</p>
        <p><strong>Tiện nghi:</strong> <%= room.getAmenities() %></p>
        <p><strong>Đánh giá:</strong> <%= room.getRatings() %> ⭐</p>
        <a href="booking.jsp?room=<%= room.getName() %>" class="btn-book">Đặt ngay</a>
    </div>
</div>

<%
    }
%>

<%@include file="footer.jsp" %>

<script>
    let images = ["images/room1.jpg", "images/room2.jpg", "images/room3.jpg"];
    let index = 0;
    
    function changeImage(step) {
        index = (index + step + images.length) % images.length;
        document.getElementById("room-image").src = images[index];
    }
</script>

</body>
</html>