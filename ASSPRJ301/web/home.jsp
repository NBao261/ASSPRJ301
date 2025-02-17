<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ - Homestay</title>
        <style>
            /* Reset CSS */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: Arial, sans-serif;
            }

            /* Header */
            .header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background: #2c3e50;
                padding: 15px 30px;
                color: white;
            }

            .header a {
                color: white;
                text-decoration: none;
                margin-left: 20px;
                font-size: 16px;
                transition: 0.3s;
            }

            .header a:hover {
                color: #f1c40f;
            }

            /* Banner chính */
            .banner {
                background: url('images/homestay-banner.jpg') no-repeat center center/cover;
                height: 450px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                text-align: center;
                padding: 20px;
                position: relative;
            }

            .banner-content {
                background: rgba(0, 0, 0, 0.5);
                padding: 40px;
                border-radius: 8px;
                max-width: 600px;
            }

            .banner h1 {
                font-size: 40px;
                margin-bottom: 15px;
                font-weight: bold;
            }

            .banner p {
                font-size: 18px;
                margin-bottom: 20px;
            }

            /* Nút Xem chi tiết */
            .btn-view-details {
                background: #3498db; /* Màu nền xanh dương */
                color: white;
                padding: 12px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-size: 18px;
                transition: background 0.3s;
                display: inline-block;
            }

            .btn-view-details:hover {
                background: #2980b9; /* Đổi màu khi rê chuột */
            }


            /* Mỗi phòng */
            .room {
                width: 100%; /* Mỗi phòng chiếm 100% chiều rộng */
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 50px; /* Khoảng cách giữa các phòng */
                transition: transform 0.3s ease, box-shadow 0.3s ease; /* Thêm hiệu ứng chuyển động */
                border-radius: 8px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); /* Đưa hiệu ứng shadow vào */
            }

            /* Khi rê chuột vào phòng */
            .room:hover {
                transform: translateY(-10px); /* Đưa phòng lên một chút khi rê chuột */
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2); /* Tăng độ mờ của shadow */
            }

            .room img {
                width: 50%; /* Ảnh chiếm 50% chiều rộng */
                object-fit: cover;
                height: auto;
                border-radius: 8px; /* Bo góc ảnh */
            }

            .room-info {
                width: 50%; /* Thông tin chiếm 50% chiều rộng */
                padding: 20px;
                text-align: left;
                border-radius: 8px;
                background-color: #fff; /* Background trắng cho thông tin */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); /* Thêm shadow cho phần thông tin */
            }

            .room h2 {
                font-size: 24px;
                margin-bottom: 10px;
                color: #333;
            }

            .room p {
                font-size: 16px;
                color: #555;
                margin-bottom: 15px;
            }

            .room .price {
                font-size: 20px;
                font-weight: bold;
                color: #2a9d8f;
                margin: 10px 0;
            }

            .room .amenities {
                font-size: 14px;
                color: #777;
                margin-bottom: 15px;
            }

            .room .ratings {
                font-size: 16px;
                font-weight: bold;
                color: #f39c12;
            }

            /* Section giới thiệu Homestay */
            .intro {
                background: #f0f0f0;
                padding: 50px;
                text-align: center;
                margin-top: 30px;
            }

            .intro h2 {
                font-size: 30px;
                margin-bottom: 20px;
                color: #333;
            }

            .intro p {
                font-size: 18px;
                color: #555;
                line-height: 1.6;
                margin-bottom: 30px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .room {
                    flex-direction: column; /* Xếp theo chiều dọc khi màn hình nhỏ */
                }

                .room img, .room-info {
                    width: 100%; /* Mỗi phần chiếm 100% chiều rộng */
                    padding: 10px;
                }

                .banner {
                    height: 350px;
                }

                .banner h1 {
                    font-size: 28px;
                }

                .banner p {
                    font-size: 16px;
                }

                .intro h2 {
                    font-size: 24px;
                }

                .intro p {
                    font-size: 16px;
                }
            }
        </style>
    </head>
    <body>
        <%@include file="header.jsp" %>

        <!-- Banner -->
        <div class="banner">
            <div class="banner-content">
                <h1>Chào mừng đến với Homestay của chúng tôi!</h1>
                <p>Trải nghiệm không gian thư giãn và dịch vụ tuyệt vời.</p>
                <a href="room-details.jsp" class="btn-view-details">Xem chi tiết</a>
            </div>
        </div>

        <!-- Giới thiệu về Homestay -->
        <section class="intro">
            <h2>Về chúng tôi</h2>
            <p>Homestay của chúng tôi mang đến không gian nghỉ dưỡng lý tưởng với các phòng sang trọng, tiện nghi đầy đủ và dịch vụ chu đáo. Chúng tôi cam kết mang lại sự thoải mái, thư giãn tuyệt đối cho quý khách.</p>
        </section>

        <!-- Danh sách phòng -->
        <section class="room-list">
            <!-- Phòng 1 -->
            <div class="room">
                <img src="images/room1.jpg" alt="Phòng Deluxe">
                <div class="room-info">
                    <h2>Phòng Deluxe</h2>
                    <p>Không gian rộng rãi, đầy đủ tiện nghi, thích hợp cho các cặp đôi hoặc những ai yêu thích sự yên tĩnh.</p>
                    <p class="price">1.200.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Điều hòa, Tủ lạnh, Bàn làm việc</p>
                    <p class="ratings">⭐ 4.5/5 (50 đánh giá)</p>
                    <a href="room-details.jsp" class="btn-view-details">Xem chi tiết</a>
                </div>
            </div>

            <!-- Phòng 2 -->
            <div class="room">
                <div class="room-info">
                    <h2>Phòng VIP</h2>
                    <p>Thiết kế sang trọng, view biển tuyệt đẹp, phục vụ cho những ai muốn tận hưởng một kỳ nghỉ đặc biệt.</p>
                    <p class="price">1.800.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Jacuzzi, Bể bơi riêng, Tủ lạnh</p>
                    <p class="ratings">⭐ 4.8/5 (120 đánh giá)</p>
                    <a href="room-details.jsp" class="btn-view-details">Xem chi tiết</a>
                </div>
                <img src="images/room2.jpg" alt="Phòng VIP">
            </div>

            <!-- Phòng 3 -->
            <div class="room">
                <img src="images/room3.jpg" alt="Phòng Gia Đình">
                <div class="room-info">
                    <h2>Phòng Gia Đình</h2>
                    <p>Lý tưởng cho gia đình, không gian rộng rãi, thoáng mát, thích hợp cho kỳ nghỉ dài ngày.</p>
                    <p class="price">2.500.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Bếp, Điều hòa, Phòng tắm riêng</p>
                    <p class="ratings">⭐ 4.7/5 (80 đánh giá)</p>
                    <a href="room-details.jsp" class="btn-view-details">Xem chi tiết</a>
                </div>
            </div>
        </section>

        <%@include file="footer.jsp" %>
    </body>
</html>
