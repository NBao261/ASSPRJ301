<%@page import="dto.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Homestay</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
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

        .main-content {
            flex: 1;
            padding: 80px 0 80px;
            overflow: auto;
        }

        /* Banner Section */
        .banner {
            background: url('https://acihome.vn/uploads/15/thiet-ke-khu-nghi-duong-homestay-la-gi.jpg') no-repeat center center/cover;
            height: 600px;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
            margin-bottom: 50px;
        }

        .banner::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        .banner-content {
            position: relative;
            z-index: 2;
            padding: 50px;
            max-width: 1000px;
            width: 90%;
            color: white;
        }

        .banner h1 {
            font-size: 50px;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 0 3px 6px rgba(0, 0, 0, 0.5);
            animation: fadeInDown 1s ease;
        }

        .banner p {
            font-size: 22px;
            font-weight: 300;
            margin-bottom: 30px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }

        .btn-view-details {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
        }

        .btn-view-details:hover {
            background: linear-gradient(45deg, #4ECDC4, #45b7d1);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
        }

        /* Intro Section */
        .intro {
            background: #fff;
            padding: 80px 40px;
            text-align: center;
            margin: 0 auto 50px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            max-width: 1200px;
            width: 90%;
            position: relative;
            overflow: hidden;
        }

        .intro::before {
            content: '';
            position: absolute;
            top: -50px;
            left: -50px;
            width: 150px;
            height: 150px;
            background: rgba(93, 193, 185, 0.2);
            border-radius: 50%;
            z-index: 0;
        }

        .intro h2 {
            font-size: 40px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #2c3e50;
            position: relative;
            z-index: 1;
        }

        .intro p {
            font-size: 18px;
            color: #666;
            line-height: 1.8;
            max-width: 800px;
            margin: 0 auto 30px;
            position: relative;
            z-index: 1;
        }

        /* Highlighted Rooms Section */
        .highlighted-rooms {
            max-width: 1200px;
            width: 90%;
            margin: 0 auto 50px;
            padding: 0 20px;
        }

        .section-title {
            text-align: center;
            font-size: 36px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 40px;
        }

        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
        }

        .room {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .room:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }

        .room img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 20px 20px 0 0;
        }

        .room-info {
            padding: 25px;
            text-align: center;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .room h3 {
            font-size: 24px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .room p {
            font-size: 16px;
            color: #666;
            margin-bottom: 15px;
            line-height: 1.6;
        }

        .room .price {
            font-size: 22px;
            font-weight: 600;
            color: #5DC1B9;
            margin: 10px 0;
        }

        .room .btn-container {
            margin-top: 20px;
        }

        /* More Rooms Link */
        .more-rooms {
            text-align: center;
            margin-top: 30px;
        }

        .more-rooms a {
            color: #5DC1B9;
            font-size: 18px;
            font-weight: 600;
            text-decoration: none;
            padding: 10px 20px;
            border: 2px solid #5DC1B9;
            border-radius: 50px;
            transition: all 0.3s ease;
        }

        .more-rooms a:hover {
            background: #5DC1B9;
            color: white;
            box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
        }

        /* Animations */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .banner {
                height: 400px;
            }

            .banner-content {
                padding: 30px;
            }

            .banner h1 {
                font-size: 32px;
            }

            .banner p {
                font-size: 18px;
            }

            .btn-view-details {
                padding: 10px 25px;
                font-size: 16px;
            }

            .intro {
                padding: 50px 20px;
            }

            .intro h2 {
                font-size: 28px;
            }

            .intro p {
                font-size: 16px;
            }

            .section-title {
                font-size: 28px;
            }

            .room img {
                height: 180px;
            }

            .room h3 {
                font-size: 20px;
            }

            .room .price {
                font-size: 18px;
            }

            .more-rooms a {
                font-size: 16px;
                padding: 8px 18px;
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
        <div class="banner">
            <div class="banner-content">
                <h1>Khám phá Homestay tuyệt vời của bạn!</h1>
                <p>Đặt ngay hôm nay để tận hưởng không gian nghỉ dưỡng đẳng cấp với giá ưu đãi.</p>
                <a href="#highlighted-rooms" class="btn-view-details">Khám phá ngay</a>
            </div>
        </div>

        <section class="intro">
            <h2>Về Homestay của chúng tôi</h2>
            <p>Chào mừng bạn đến với Homestay của sự thư giãn và đẳng cấp. Chúng tôi mang đến không gian sống ấm cúng, tiện nghi hiện đại và dịch vụ tận tâm, giúp bạn có một kỳ nghỉ đáng nhớ giữa lòng thiên nhiên.</p>
        </section>

        <section id="highlighted-rooms" class="highlighted-rooms">
            <h2 class="section-title">Phòng nổi bật</h2>
            <div class="room-grid">
                <div class="room">
                    <img src="https://mia.vn/media/uploads/blog-du-lich/top-11-homestay-ba-vi-01-1700960372.jpeg" alt="Phòng Deluxe">
                    <div class="room-info">
                        <div>
                            <h3>Phòng Deluxe</h3>
                            <p>Không gian ấm cúng, lý tưởng cho các cặp đôi.</p>
                            <p class="price">1.200.000đ / đêm</p>
                        </div>
                        <div class="btn-container">
                            <% if (user != null) { %>
                            <a href="room-details?roomId=1" class="btn-view-details">Xem chi tiết</a>
                            <% } else { %>
                            <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="room">
                    <img src="https://dongtiengroup.vn/wp-content/uploads/2024/05/thiet-ke-homestay-nha-vuon-5.jpg" alt="Phòng VIP">
                    <div class="room-info">
                        <div>
                            <h3>Phòng VIP</h3>
                            <p>Sang trọng với view biển tuyệt đẹp.</p>
                            <p class="price">1.800.000đ / đêm</p>
                        </div>
                        <div class="btn-container">
                            <% if (user != null) { %>
                            <a href="room-details?roomId=2" class="btn-view-details">Xem chi tiết</a>
                            <% } else { %>
                            <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                            <% } %>
                        </div>
                    </div>
                </div>

                <div class="room">
                    <img src="https://sakos.vn/wp-content/uploads/2023/05/momo-upload-api-220510091852-637877711328579007.jpeg" alt="Phòng Gia Đình">
                    <div class="room-info">
                        <div>
                            <h3>Phòng Gia Đình</h3>
                            <p>Rộng rãi, thoáng mát cho cả gia đình.</p>
                            <p class="price">2.500.000đ / đêm</p>
                        </div>
                        <div class="btn-container">
                            <% if (user != null) { %>
                            <a href="room-details?roomId=3" class="btn-view-details">Xem chi tiết</a>
                            <% } else { %>
                            <a href="login-regis.jsp" class="btn-view-details">Đăng nhập để đặt</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            <div class="more-rooms">
                <a href="<%= request.getContextPath() %>/search.jsp">Xem nhiều phòng khác tại đây</a>
            </div>
        </section>
    </div>

    <div class="footer-container">
        <%@include file="footer.jsp" %>
    </div>
</body>
</html>