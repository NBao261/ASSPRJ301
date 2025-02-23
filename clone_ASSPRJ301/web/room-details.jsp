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
            font-family: 'Arial', sans-serif;
        }

        body {
            background-color: #f8f9fa;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* CONTAINER CHI TIẾT PHÒNG */
        .room-details {
            max-width: 1200px;
            margin: 120px auto 80px;
            padding: 40px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            gap: 40px;
        }

        /* SLIDESHOW ẢNH */
        .room-gallery {
            position: relative;
            overflow: hidden;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .room-gallery img {
            width: 100%;
            height: 450px;
            object-fit: cover;
            border-radius: 15px;
            transition: opacity 0.5s ease-in-out;
        }

        .prev, .next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 0, 0, 0.6);
            color: white;
            border: none;
            padding: 15px;
            cursor: pointer;
            border-radius: 50%;
            font-size: 24px;
            transition: background 0.3s ease;
        }

        .prev:hover, .next:hover {
            background: rgba(0, 0, 0, 0.9);
        }

        .prev { left: 20px; }
        .next { right: 20px; }

        /* THÔNG TIN CHI TIẾT */
        .room-info {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
        }

        .room-info h2 {
            font-size: 32px;
            margin-bottom: 20px;
            color: #2c3e50;
        }

        .room-info p {
            font-size: 18px;
            margin-bottom: 15px;
            line-height: 1.8;
        }

        .room-info strong {
            color: #27ae60;
        }

        /* NÚT ĐẶT PHÒNG */
        .btn-book {
            display: inline-block;
            margin-top: 25px;
            padding: 15px 30px;
            background: #e74c3c;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            transition: background 0.3s, transform 0.2s;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }

        .btn-book:hover {
            background: #ff6b6b;
            transform: scale(1.05);
        }

        /* ẢNH CHI TIẾT */
        .room-gallery-details {
            margin-top: 30px;
        }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            margin-top: 15px;
        }

        .gallery-grid img {
            width: 100%;
            height: 150px;
            object-fit: cover;
            border-radius: 10px;
            transition: transform 0.3s ease;
        }

        .gallery-grid img:hover {
            transform: scale(1.05);
        }

        /* VỊ TRÍ */
        .room-location {
            margin-top: 30px;
        }

        .room-location iframe {
            width: 100%;
            height: 300px;
            border: 0;
            border-radius: 10px;
            margin-top: 15px;
        }

        /* TIỆN ÍCH (CẢI TIẾN) */
        .room-amenities {
            margin-top: 30px;
        }

        .amenities-list {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 15px;
        }

        .amenity-item {
            display: flex;
            align-items: center;
            gap: 10px;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .amenity-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .amenity-item i {
            font-size: 24px;
            color: #27ae60;
        }

        .amenity-item p {
            margin: 0;
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }

        /* ĐÁNH GIÁ TRỰC TIẾP */
        .room-reviews {
            margin-top: 30px;
        }

        .review-form {
            margin-top: 20px;
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
        }

        .review-form h4 {
            margin-bottom: 15px;
            font-size: 20px;
            color: #2c3e50;
        }

        .rating-stars {
            display: flex;
            gap: 5px;
            margin-bottom: 15px;
        }

        .rating-stars .star {
            font-size: 24px;
            color: #ccc;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .rating-stars .star.active {
            color: #ffcc00;
        }

        .review-form textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            margin-bottom: 15px;
            resize: vertical;
        }

        .review-form button {
            padding: 10px 20px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .review-form button:hover {
            background: #219653;
        }

        .review-list {
            margin-top: 20px;
        }

        .review-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 10px;
        }

        .review-item p {
            margin: 5px 0;
        }

        .review-item .rating {
            color: #ffcc00;
            font-size: 18px;
        }

        /* CHIA SẺ */
        .room-share {
            margin-top: 30px;
        }

        .share-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }

        .share-btn {
            display: flex;
            align-items: center;
            gap: 5px;
            padding: 10px 15px;
            background: #3b5998;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.3s ease;
        }

        .share-btn:hover {
            background: #2d4373;
        }

        .share-btn.twitter { background: #1da1f2; }
        .share-btn.twitter:hover { background: #1991db; }

        .share-btn.zalo { background: #0068ff; }
        .share-btn.zalo:hover { background: #0056cc; }

        /* Responsive Design */
        @media (max-width: 768px) {
            .room-details {
                margin: 100px auto 50px;
                padding: 20px;
                gap: 20px;
            }

            .room-info {
                grid-template-columns: 1fr;
            }

            .room-gallery img {
                height: 300px;
            }

            .room-info h2 {
                font-size: 28px;
            }

            .room-info p {
                font-size: 16px;
            }

            .btn-book {
                width: 100%;
                text-align: center;
            }

            .gallery-grid {
                grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            }

            .room-video iframe {
                height: 250px;
            }
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
    <!-- Slideshow ảnh -->
    <div class="room-gallery">
        <img id="room-image" src="<%= room.getImageUrl() %>" alt="<%= room.getName() %>">
        <button class="prev" onclick="changeImage(-1)">&#10094;</button>
        <button class="next" onclick="changeImage(1)">&#10095;</button>
    </div>

    <!-- Thông tin chi tiết -->
    <div class="room-info">
        <div>
            <h2><%= room.getName() %></h2>
            <p><%= room.getDescription() %></p>
            <p><strong>Giá:</strong> <%= room.getPrice() %>đ / đêm</p>
            <p><strong>Tiện nghi:</strong> <%= room.getAmenities() %></p>
            <p><strong>Đánh giá:</strong> <%= room.getRatings() %> ⭐</p>
            <a href="booking.jsp?roomId=<%= room.getId()%>" class="btn-book">Đặt ngay</a>
        </div>

        <!-- Ảnh chi tiết -->
        <div class="room-gallery-details">
            <h3>Ảnh chi tiết</h3>
            <div class="gallery-grid">
                <img src="images/room-bathroom.jpg" alt="Phòng tắm">
                <img src="images/room-workspace.jpg" alt="Góc làm việc">
                <img src="images/room-view.jpg" alt="View từ cửa sổ">
            </div>
        </div>
    </div>

    <!-- Vị trí -->
    <div class="room-location">
        <h3>Vị trí</h3>
        <p><strong>Địa chỉ:</strong> 123 Đường ABC, Quận XYZ, Thành phố HCM</p>
        <iframe
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.1234567890123!2d106.12345678901234!3d10.123456789012345!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTDCsDA3JzI0LjQiTiAxMDbCsDA3JzI0LjQiRQ!5e0!3m2!1sen!2s!4v1234567890123!5m2!1sen!2s"
            allowfullscreen=""
            loading="lazy">
        </iframe>
    </div>

    <!-- Tiện ích (Cải tiến) -->
    <div class="room-amenities">
        <h3>Tiện ích</h3>
        <div class="amenities-list">
            <div class="amenity-item">
                <i class="fas fa-wifi"></i>
                <p>Wifi miễn phí</p>
            </div>
            <div class="amenity-item">
                <i class="fas fa-swimming-pool"></i>
                <p>Hồ bơi</p>
            </div>
            <div class="amenity-item">
                <i class="fas fa-parking"></i>
                <p>Bãi đỗ xe</p>
            </div>
            <div class="amenity-item">
                <i class="fas fa-utensils"></i>
                <p>Bữa sáng miễn phí</p>
            </div>
        </div>
    </div>

    <!-- Đánh giá trực tiếp -->
    <div class="room-reviews">
        <h3>Đánh giá</h3>
        <div class="review-form">
            <h4>Viết đánh giá của bạn</h4>
            <div class="rating-stars">
                <span class="star" data-value="1">&#9733;</span>
                <span class="star" data-value="2">&#9733;</span>
                <span class="star" data-value="3">&#9733;</span>
                <span class="star" data-value="4">&#9733;</span>
                <span class="star" data-value="5">&#9733;</span>
            </div>
            <textarea placeholder="Nhập bình luận của bạn..." rows="4"></textarea>
            <button type="button">Gửi đánh giá</button>
        </div>
        <div class="review-list">
            <div class="review-item">
                <p><strong>Nguyễn Văn A:</strong></p>
                <p class="rating">⭐⭐⭐⭐⭐</p>
                <p>Phòng rất đẹp, view tuyệt vời, dịch vụ tốt!</p>
            </div>
            <div class="review-item">
                <p><strong>Trần Thị B:</strong></p>
                <p class="rating">⭐⭐⭐⭐</p>
                <p>Phòng sạch sẽ, giá cả hợp lý.</p>
            </div>
        </div>
    </div>

    <!-- Chia sẻ -->
    <div class="room-share">
        <h3>Chia sẻ</h3>
        <div class="share-buttons">
            <a href="https://www.facebook.com/sharer/sharer.php?u=URL_PHÒNG" target="_blank" class="share-btn">
                <i class="fab fa-facebook-f"></i> Facebook
            </a>
            <a href="https://twitter.com/intent/tweet?url=URL_PHÒNG" target="_blank" class="share-btn twitter">
                <i class="fab fa-twitter"></i> Twitter
            </a>
            <a href="https://zalo.me/share?url=URL_PHÒNG" target="_blank" class="share-btn zalo">
                <i class="fab fa-zalo"></i> Zalo
            </a>
        </div>
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

    // Xử lý đánh giá sao
    const stars = document.querySelectorAll('.rating-stars .star');
    stars.forEach(star => {
        star.addEventListener('click', () => {
            const value = star.getAttribute('data-value');
            stars.forEach((s, i) => {
                if (i < value) {
                    s.classList.add('active');
                } else {
                    s.classList.remove('active');
                }
            });
        });
    });
</script>

<!-- Import FontAwesome -->
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

</body>
</html>