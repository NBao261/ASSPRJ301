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
                height: 400px;
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
                padding: 30px;
                border-radius: 8px;
            }

            .banner h1 {
                font-size: 36px;
                margin-bottom: 15px;
            }

            .banner p {
                font-size: 18px;
                margin-bottom: 20px;
            }

            .btn-book {
                background: #e76f51;
                color: white;
                padding: 12px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-size: 18px;
                transition: background 0.3s;
            }

            .btn-book:hover {
                background: #d63e22;
            }

            /* Danh sách phòng */
            .room-list {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
                padding: 50px;
                text-align: center;
            }

            .room {
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .room img {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }

            .room-info {
                padding: 15px;
            }

            .room h2 {
                font-size: 22px;
                margin-bottom: 10px;
            }

            .room p {
                font-size: 16px;
                color: #555;
            }

            .room .price {
                font-size: 18px;
                font-weight: bold;
                color: #2a9d8f;
                margin: 10px 0;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .banner {
                    height: 300px;
                }

                .banner h1 {
                    font-size: 28px;
                }

                .banner p {
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
                <a href="booking.jsp" class="btn-book">Đặt phòng ngay</a>
            </div>
        </div>

        <!-- Danh sách phòng -->
        <section class="room-list">
            <div class="room">
                <img src="images/room1.jpg" alt="Phòng Deluxe">
                <div class="room-info">
                    <h2>Phòng Deluxe</h2>
                    <p>Không gian rộng rãi, đầy đủ tiện nghi.</p>
                    <p class="price">1.200.000đ / đêm</p>
                    <a href="booking.jsp" class="btn-book">Đặt ngay</a>
                </div>
            </div>

            <div class="room">
                <img src="images/room2.jpg" alt="Phòng VIP">
                <div class="room-info">
                    <h2>Phòng VIP</h2>
                    <p>Thiết kế sang trọng, view biển tuyệt đẹp.</p>
                    <p class="price">1.800.000đ / đêm</p>
                    <a href="booking.jsp" class="btn-book">Đặt ngay</a>
                </div>
            </div>

            <div class="room">
                <img src="images/room3.jpg" alt="Phòng Gia Đình">
                <div class="room-info">
                    <h2>Phòng Gia Đình</h2>
                    <p>Lý tưởng cho gia đình, không gian thoáng mát.</p>
                    <p class="price">2.500.000đ / đêm</p>
                    <a href="booking.jsp" class="btn-book">Đặt ngay</a>
                </div>
            </div>
        </section>

        <%@include file="footer.jsp" %>
    </body>
</html>
