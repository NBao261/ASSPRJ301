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

        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 80px 0 80px; /* Space for fixed header (60px) and footer (80px) */
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
            max-width: 800px;
            backdrop-filter: blur(5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }

        .banner-content:hover {
            transform: translateY(-5px);
        }

        .banner h1 {
            font-size: 48px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .banner p {
            font-size: 20px;
            margin-bottom: 25px;
            text-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
        }

        .btn-view-details {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4); /* Match header/footer gradient */
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
        }

        .btn-view-details:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
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
        }

        .room {
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            background: white;
        }

        .room:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        .room img {
            width: 50%;
            object-fit: cover;
            height: 300px; /* Fixed height for consistency */
            border-radius: 15px 0 0 15px;
        }

        .room-info {
            width: 50%;
            padding: 25px;
            text-align: left;
            border-radius: 0 15px 15px 0;
        }

        .room h2 {
            font-size: 28px;
            margin-bottom: 15px;
            color: #2c3e50;
        }

        .room p {
            font-size: 16px;
            color: #555;
            margin-bottom: 12px;
            line-height: 1.6;
        }

        .room .price {
            font-size: 24px;
            font-weight: 600;
            color: #5DC1B9; /* Match header/footer color */
            margin: 15px 0;
        }

        .room .amenities {
            font-size: 14px;
            color: #777;
            margin-bottom: 15px;
        }

        .room .ratings {
            font-size: 16px;
            font-weight: 600;
            color: #f39c12;
        }

        .room .btn-view-details {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            display: inline-block;
            box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
        }

        .room .btn-view-details:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: translateY(-3px);
            box-shadow: 0 6px 15px rgba(93, 193, 185, 0.6);
        }

        html {
            scroll-behavior: smooth;
        }

        @media (max-width: 768px) {
            .main-content {
                padding: 60px 0 70px; /* Adjust for mobile header (50px) and footer (70px) */
            }

            .banner {
                height: 300px;
            }

            .banner-content {
                padding: 20px;
                max-width: 90%;
            }

            .banner h1 {
                font-size: 28px;
            }

            .banner p {
                font-size: 16px;
            }

            .btn-view-details {
                padding: 10px 18px;
                font-size: 16px;
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

            .room {
                flex-direction: column;
                margin-bottom: 20px;
            }

            .room img, .room-info {
                width: 100%;
                padding: 15px;
            }

            .room img {
                height: 200px; /* Reduced height for mobile */
            }

            .room h2 {
                font-size: 22px;
            }

            .room .price {
                font-size: 20px;
            }

            .room .btn-view-details {
                padding: 8px 16px;
                font-size: 14px;
            }
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
                    <h2>Phòng Deluxe</h2>
                    <p>Không gian rộng rãi, đầy đủ tiện nghi, thích hợp cho các cặp đôi hoặc những ai yêu thích sự yên tĩnh.</p>
                    <p class="price">1.200.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Điều hòa, Tủ lạnh, Bàn làm việc</p>
                    <p class="ratings">⭐ 4.5/5 (50 đánh giá)</p>

                    <%
                        if (user != null) {
                    %>
                    <a href="room-details?roomId=1" class="btn-view-details">Xem chi tiết</a>
                    <% } else { %>
                    <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                    <% } %>
                </div>
            </div>

            <!-- Room 2 -->
            <div class="room">
                <div class="room-info">
                    <h2>Phòng VIP</h2>
                    <p>Thiết kế sang trọng, view biển tuyệt đẹp, phục vụ cho những ai muốn tận hưởng một kỳ nghỉ đặc biệt.</p>
                    <p class="price">1.800.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Jacuzzi, Bể bơi riêng, Tủ lạnh</p>
                    <p class="ratings">⭐ 4.8/5 (120 đánh giá)</p>

                    <%
                        if (user != null) {
                    %>
                    <a href="room-details?roomId=2" class="btn-view-details">Xem chi tiết</a>
                    <% } else { %>
                    <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                    <% } %>
                </div>
                <img src="https://dongtiengroup.vn/wp-content/uploads/2024/05/thiet-ke-homestay-nha-vuon-5.jpg" alt="Phòng VIP">
            </div>

            <!-- Room 3 -->
            <div class="room">
                <img src="https://sakos.vn/wp-content/uploads/2023/05/momo-upload-api-220510091852-637877711328579007.jpeg" alt="Phòng Gia Đình">
                <div class="room-info">
                    <h2>Phòng Gia Đình</h2>
                    <p>Lý tưởng cho gia đình, không gian rộng rãi, thoáng mát, thích hợp cho kỳ nghỉ dài ngày.</p>
                    <p class="price">2.500.000đ / đêm</p>
                    <p class="amenities">Tiện nghi: Wifi, TV, Bếp, Điều hòa, Phòng tắm riêng</p>
                    <p class="ratings">⭐ 4.7/5 (80 đánh giá)</p>

                    <%
                        if (user != null) {
                    %>
                    <a href="room-details?roomId=3" class="btn-view-details">Xem chi tiết</a>
                    <% } else { %>
                    <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                    <% } %>
                </div>
            </div>
        </section>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>