<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phòng - Homestay</title>
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

        /* Banner chi tiết phòng */
        .room-detail-banner {
            background: url('images/detail-banner.jpg') no-repeat center center/cover;
            height: 400px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
            position: relative;
        }

        .banner-content {
            background: rgba(0, 0, 0, 0.5);
            padding: 30px;
            border-radius: 8px;
        }

        .banner h1 {
            font-size: 36px;
        }

        /* Phần thông tin chi tiết phòng */
        .room-details {
            display: flex;
            justify-content: space-between;
            padding: 40px;
            flex-wrap: wrap;
        }

        .room-gallery {
            width: 60%;
        }

        .room-gallery img {
            width: 100%;
            margin-bottom: 15px;
            border-radius: 8px;
        }

        .room-info {
            width: 35%;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        .room-info h2 {
            font-size: 30px;
            margin-bottom: 15px;
        }

        .room-info p {
            font-size: 16px;
            margin-bottom: 10px;
            color: #555;
        }

        .price {
            font-size: 22px;
            font-weight: bold;
            color: #e76f51;
            margin-top: 20px;
        }

        /* Đánh giá */
        .reviews {
            margin-top: 40px;
        }

        .reviews h3 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .review-item {
            background: #f9f9f9;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .review-item .reviewer {
            font-weight: bold;
            margin-bottom: 10px;
        }

        .review-item .review-text {
            font-size: 16px;
            color: #777;
        }

        .btn-book {
            background: #e76f51;
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
            transition: background 0.3s;
            margin-top: 30px;
            display: inline-block;
        }

        .btn-book:hover {
            background: #d63e22;
        }
    </style>
</head>
<body>

<%@include file="header.jsp" %>

<!-- Banner chi tiết phòng -->
<div class="room-detail-banner">
    <div class="banner-content">
        <h1>Chi tiết Phòng Deluxe</h1>
    </div>
</div>

<!-- Thông tin chi tiết phòng -->
<div class="room-details">
    <!-- Phòng Gallery (nhiều ảnh) -->
    <div class="room-gallery">
        <img src="images/room1.jpg" alt="Phòng Deluxe">
        <img src="images/room2.jpg" alt="Phòng Deluxe - 2">
        <img src="images/room3.jpg" alt="Phòng Deluxe - 3">
    </div>

    <!-- Thông tin phòng -->
    <div class="room-info">
        <h2>Phòng Deluxe</h2>
        <p>Không gian rộng rãi, trang bị đầy đủ tiện nghi hiện đại, thích hợp cho kỳ nghỉ thư giãn với gia đình hoặc bạn bè.</p>
        <p class="price">1.200.000đ / đêm</p>
        <p>Điểm nổi bật: Có ban công riêng, view biển đẹp, Wi-Fi tốc độ cao miễn phí, TV màn hình phẳng, điều hòa, minibar.</p>
        <a href="booking.jsp" class="btn-book">Đặt ngay</a>
    </div>
</div>

<!-- Đánh giá -->
<div class="reviews">
    <h3>Đánh giá của khách hàng</h3>

    <div class="review-item">
        <div class="reviewer">Nguyễn Văn A</div>
        <div class="review-text">Phòng rất đẹp, view biển tuyệt vời, dịch vụ chu đáo. Tôi đã có một kỳ nghỉ tuyệt vời ở đây!</div>
    </div>

    <div class="review-item">
        <div class="reviewer">Trần Thị B</div>
        <div class="review-text">Phòng sạch sẽ, tiện nghi đầy đủ, không gian thoải mái. Mình sẽ quay lại nếu có dịp!</div>
    </div>

    <div class="review-item">
        <div class="reviewer">Lê Minh C</div>
        <div class="review-text">Dịch vụ tuyệt vời, mọi thứ đều rất hoàn hảo. Mình sẽ giới thiệu cho bạn bè!</div>
    </div>
</div>

<%@include file="footer.jsp" %>

</body>
</html>
