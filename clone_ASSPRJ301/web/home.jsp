<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Homestay</title>
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

        /* Header and Footer Containers */
        .header-container, .footer-container {
            width: 100%;
            z-index: 1000;
        }

        .main-content {
            flex: 1;
            padding: 80px 0 80px;
            overflow: auto;
        }

        /* Banner Section */
        .banner {
            background: url('https://acihome.vn/uploads/15/thiet-ke-khu-nghi-duong-homestay-la-gi.jpg') no-repeat center center/cover;
            height: 500px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            position: relative;
            margin-bottom: 40px;
        }

        .banner-content {
            background: rgba(0, 0, 0, 0.5);
            padding: 40px;
            border-radius: 15px;
            max-width: 900px;
            width: 90%;
            backdrop-filter: blur(5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .banner-content:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.4);
        }

        .banner h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.4);
        }

        .banner p {
            font-size: 20px;
            margin-bottom: 30px;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.4);
        }

        .btn-view-details {
            background: #5DC1B9;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.3s ease, box-shadow 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
        }

        .btn-view-details:hover {
            background: #4ECDC4;
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(93, 193, 185, 0.6);
        }

        /* Intro Section */
        .intro {
            background: #ffffff;
            padding: 60px 40px;
            text-align: center;
            margin: 0 auto 40px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            max-width: 1200px;
            width: 90%;
        }

        .intro h2 {
            font-size: 36px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .intro p {
            font-size: 18px;
            color: #555;
            line-height: 1.8;
            margin-bottom: 30px;
        }

        /* Room List Section */
        .room-list {
            max-width: 1200px;
            width: 90%;
            margin: 0 auto 40px;
            padding: 0 20px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }

        .room {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .room:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        .room img {
            width: 100%;
            object-fit: cover;
            height: 250px;
            border-radius: 15px 15px 0 0;
        }

        .room-info {
            padding: 25px;
            text-align: center; /* Căn giữa toàn bộ nội dung trong room-info */
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: center; /* Đảm bảo nội dung được căn giữa theo chiều dọc */
            align-items: center; /* Căn giữa theo chiều ngang */
        }

        .room h2 {
            font-size: 24px;
            margin-bottom: 15px;
            color: #2c3e50;
        }

        .room p {
            font-size: 16px;
            color: #555;
            margin-bottom: 12px;
            line-height: 1.6;
            text-align: center; /* Căn giữa từng đoạn văn bản */
        }

        .room .price {
            font-size: 22px;
            font-weight: 600;
            color: #5DC1B9;
            margin: 15px 0;
        }

        .room .amenities {
            font-size: 14px;
            color: #777;
            margin-bottom: 15px;
            text-align: center; /* Căn giữa tiện nghi */
        }

        .room .ratings {
            font-size: 16px;
            font-weight: 600;
            color: #f39c12;
            margin-bottom: 20px;
        }

        .room .btn-container {
            text-align: center; /* Đảm bảo nút luôn được căn giữa */
            margin-top: 20px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                padding: 60px 0 70px;
            }

            .banner {
                height: 300px;
            }

            .banner-content {
                padding: 20px;
                max-width: 85%;
            }

            .banner h1 {
                font-size: 28px;
            }

            .banner p {
                font-size: 16px;
            }

            .btn-view-details {
                padding: 8px 18px;
                font-size: 14px;
            }

            .intro {
                padding: 40px 20px;
                margin: 0 auto 20px;
            }

            .intro h2 {
                font-size: 24px;
            }

            .intro p {
                font-size: 16px;
            }

            .room img {
                height: 200px;
            }

            .room h2 {
                font-size: 20px;
            }

            .room .price {
                font-size: 18px;
            }

            .room .btn-view-details {
                padding: 8px 16px;
                font-size: 14px;
            }
        }

        /* Smooth scrolling */
        html {
            scroll-behavior: smooth;
        }
    </style>
    <!-- Include FontAwesome for footer.jsp -->
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
</head>
<body>
    <div class="header-container">
        <%@include file="header.jsp" %>
    </div>

    <div class="main-content">
        <div class="banner">
            <div class="banner-content">
                <h1>Chào mừng đến với Homestay của chúng tôi!</h1>
                <p>Trải nghiệm không gian thư giãn và dịch vụ tuyệt vời.</p>
                <a href="#room-list" class="btn-view-details">Xem chi tiết</a>
            </div>
        </div>

        <section class="intro">
            <h2>Về chúng tôi</h2>
            <p>Homestay của chúng tôi mang đến không gian nghỉ dưỡng lý tưởng với các phòng sang trọng, tiện nghi đầy đủ và dịch vụ chu đáo. Chúng tôi cam kết mang lại sự thoải mái, thư giãn tuyệt đối cho quý khách.</p>
        </section>

        <!-- Room List Section -->
        <section id="room-list" class="room-list">
            <!-- Room 1 -->
            <div class="room">
                <img src="https://mia.vn/media/uploads/blog-du-lich/top-11-homestay-ba-vi-01-1700960372.jpeg" alt="Phòng Deluxe">
                <div class="room-info">
                    <div>
                        <h2>Phòng Deluxe</h2>
                        <p>Không gian rộng rãi, đầy đủ tiện nghi, thích hợp cho các cặp đôi hoặc những ai yêu thích sự yên tĩnh.</p>
                        <p class="price">1.200.000đ / đêm</p>
                        <p class="amenities">Tiện nghi: Wifi, TV, Điều hòa, Tủ lạnh, Bàn làm việc</p>
                        <p class="ratings">⭐ 4.5/5 (50 đánh giá)</p>
                    </div>
                    <div class="btn-container">
                        <%
                            if (user != null) {
                        %>
                        <a href="room-details?roomId=1" class="btn-view-details">Xem chi tiết</a>
                        <% } else { %>
                        <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Room 2 -->
            <div class="room">
                <img src="https://dongtiengroup.vn/wp-content/uploads/2024/05/thiet-ke-homestay-nha-vuon-5.jpg" alt="Phòng VIP">
                <div class="room-info">
                    <div>
                        <h2>Phòng VIP</h2>
                        <p>Thiết kế sang trọng, view biển tuyệt đẹp, phục vụ cho những ai muốn tận hưởng một kỳ nghỉ đặc biệt.</p>
                        <p class="price">1.800.000đ / đêm</p>
                        <p class="amenities">Tiện nghi: Wifi, TV, Jacuzzi, Bể bơi riêng, Tủ lạnh</p>
                        <p class="ratings">⭐ 4.8/5 (120 đánh giá)</p>
                    </div>
                    <div class="btn-container">
                        <%
                            if (user != null) {
                        %>
                        <a href="room-details?roomId=2" class="btn-view-details">Xem chi tiết</a>
                        <% } else { %>
                        <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Room 3 -->
            <div class="room">
                <img src="https://sakos.vn/wp-content/uploads/2023/05/momo-upload-api-220510091852-637877711328579007.jpeg" alt="Phòng Gia Đình">
                <div class="room-info">
                    <div>
                        <h2>Phòng Gia Đình</h2>
                        <p>Lý tưởng cho gia đình, không gian rộng rãi, thoáng mát, thích hợp cho kỳ nghỉ dài ngày.</p>
                        <p class="price">2.500.000đ / đêm</p>
                        <p class="amenities">Tiện nghi: Wifi, TV, Bếp, Điều hòa, Phòng tắm riêng</p>
                        <p class="ratings">⭐ 4.7/5 (80 đánh giá)</p>
                    </div>
                    <div class="btn-container">
                        <%
                            if (user != null) {
                        %>
                        <a href="room-details?roomId=3" class="btn-view-details">Xem chi tiết</a>
                        <% } else { %>
                        <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>