<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="dto.RoomDTO" %>
<%@ page import="dto.ReviewDTO" %>
<%@ page import="dao.ReviewDAO" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="dto.UserDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết phòng</title>
        <style>
            /* Giữ nguyên toàn bộ CSS từ file cũ */
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
                display: flex;
                flex-direction: column;
                padding: 80px 0 80px;
                overflow: auto;
                max-width: 1200px;
                margin: 0 auto;
                width: 90%;
            }
            .room-details {
                background: white;
                border-radius: 15px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                padding: 40px;
                margin-bottom: 20px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .room-details:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
            }
            .room-gallery {
                position: relative;
                overflow: hidden;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
            }
            .room-gallery img {
                width: 100%;
                height: 500px;
                object-fit: cover;
                border-radius: 15px;
                display: none;
                transition: opacity 0.5s ease-in-out;
            }
            .room-gallery img.active {
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
            .room-info {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 40px;
                margin-bottom: 30px;
            }
            .room-info h2 {
                font-size: 36px;
                font-weight: 700;
                margin-bottom: 20px;
                color: #2c3e50;
            }
            .room-info p {
                font-size: 18px;
                margin-bottom: 15px;
                line-height: 1.8;
                color: #555;
            }
            .room-info strong {
                color: #5DC1B9;
            }
            .btn-book {
                display: inline-block;
                margin-top: 25px;
                padding: 14px 30px;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                text-decoration: none;
                border-radius: 10px;
                font-size: 18px;
                font-weight: 600;
                transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
                box-shadow: 0 4px 15px rgba(93, 193, 185, 0.4);
            }
            .btn-book:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                transform: scale(1.05);
                box-shadow: 0 6px 20px rgba(93, 193, 185, 0.6);
            }
            .room-location {
                margin-top: 30px;
            }
            .room-location h3 {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #2c3e50;
            }
            .room-location p {
                font-size: 18px;
                margin-bottom: 15px;
                color: #555;
            }
            .room-location iframe {
                width: 100%;
                height: 350px;
                border: 0;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                transition: box-shadow 0.3s ease;
            }
            .room-location iframe:hover {
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
            }
            .room-amenities {
                margin-top: 30px;
            }
            .room-amenities h3 {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #2c3e50;
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
                gap: 12px;
                background: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }
            .amenity-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .amenity-item i {
                font-size: 24px;
                color: #5DC1B9;
            }
            .amenity-item p {
                margin: 0;
                font-size: 16px;
                font-weight: 500;
                color: #333;
            }
            .room-reviews {
                margin-top: 30px;
            }
            .room-reviews h3 {
                font-size: 24px;
                font-weight: 600;
                margin-bottom: 15px;
                color: #2c3e50;
            }
            .review-form {
                margin-top: 20px;
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            }
            .review-form h4 {
                margin-bottom: 15px;
                font-size: 20px;
                font-weight: 600;
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
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                margin-bottom: 15px;
                resize: vertical;
                transition: border-color 0.3s ease;
            }
            .review-form textarea:focus {
                border-color: #5DC1B9;
                outline: none;
            }
            .review-form button {
                padding: 12px 25px;
                background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
                color: white;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: background 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
                box-shadow: 0 4px 12px rgba(93, 193, 185, 0.4);
            }
            .review-form button:hover {
                background: linear-gradient(45deg, #4ECDC4, #45b7d1);
                transform: scale(1.05);
                box-shadow: 0 6px 15px rgba(93, 193, 185, 0.6);
            }
            .review-list {
                margin-top: 20px;
            }
            .review-item {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 15px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .review-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .review-item p {
                margin: 5px 0;
                font-size: 16px;
                color: #555;
            }
            .review-item .rating {
                color: #ffcc00;
                font-size: 18px;
                font-weight: 600;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px 70px;
                }
                .room-details {
                    margin: 100px auto 20px;
                    padding: 20px;
                }
                .room-gallery img {
                    height: 300px;
                }
                .room-info {
                    grid-template-columns: 1fr;
                    gap: 20px;
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
                    padding: 12px 25px;
                }
                .room-location iframe {
                    height: 250px;
                }
                .room-amenities h3, .room-reviews h3 {
                    font-size: 20px;
                }
                .amenities-list {
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                    gap: 15px;
                }
                .amenity-item {
                    padding: 12px;
                }
                .review-form {
                    padding: 15px;
                }
                .review-form button {
                    padding: 10px 18px;
                    font-size: 14px;
                }
                .review-item {
                    padding: 12px;
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
                RoomDTO room = (RoomDTO) request.getAttribute("room");
                if (room == null) {
            %>
            <div style="text-align: center; margin-top: 50px;">
                <h2 style="font-size: 28px; color: #2c3e50;">Không tìm thấy thông tin phòng!</h2>
                <a href="home.jsp" class="btn-book" style="background: linear-gradient(45deg, #5DC1B9, #4ECDC4); padding: 12px 25px; font-size: 18px;">Quay lại trang chủ</a>
            </div>
            <%
            } else {
            %>

            <div class="room-details">
                <!-- Slideshow Gallery -->
                <div class="room-gallery">
                    <%
                        List<String> detailImages = room.getDetailImages();
                        if (detailImages == null || detailImages.isEmpty()) {
                            detailImages = new java.util.ArrayList<String>();
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

                <!-- Room Info -->
                <div class="room-info">
                    <div>
                        <h2><%= room.getName()%></h2>
                        <p><%= room.getDescription()%></p>
                        <p><strong>Giá:</strong> <%= String.format("%,.0f", room.getPrice())%>đ / đêm</p>
                        <p><strong>Tiện nghi:</strong> <%= room.getAmenities()%></p>
                        <p><strong>Đánh giá:</strong> <%= room.getRatings()%> ⭐</p>
                        <a href="booking.jsp?roomId=<%= room.getId()%>" class="btn-book">Đặt ngay</a>
                    </div>
                </div>

                <!-- Location -->
                <div class="room-location">
                    <h3>Vị trí</h3>
                    <p><strong>Địa chỉ:</strong> <b>S702 Vinhome Grand Park, Quận 9</b></p>
                    <iframe src="https://maps.google.com/maps?width=100%25&height=600&hl=en&q=S702%20Vinhomes%20GrandPark,%20Qu%E1%BA%ADn%209+(HomeStay)&t=&z=14&ie=UTF8&iwloc=B&output=embed" allowfullscreen="" loading="lazy"></iframe>
                </div>

                <!-- Amenities -->
                <div class="room-amenities">
                    <h3>Tiện ích</h3>
                    <div class="amenities-list">
                        <div class="amenity-item"><i class="fas fa-wifi"></i><p>Wifi miễn phí</p></div>
                        <div class="amenity-item"><i class="fas fa-swimming-pool"></i><p>Hồ bơi</p></div>
                        <div class="amenity-item"><i class="fas fa-parking"></i><p>Bãi đỗ xe</p></div>
                        <div class="amenity-item"><i class="fas fa-utensils"></i><p>Nhiều tiện ích xung quanh</p></div>
                    </div>
                </div>

                <!-- Reviews -->
                <div class="room-reviews">
                    <h3>Đánh giá</h3>
                    <% if (user != null) { %>
                    <div class="review-form">
                        <h4>Viết đánh giá của bạn</h4>
                        <form action="submit-review" method="post">
                            <input type="hidden" name="roomId" value="<%= room.getId() %>">
                            <div class="rating-stars">
                                <span class="star" data-value="1">★</span>
                                <span class="star" data-value="2">★</span>
                                <span class="star" data-value="3">★</span>
                                <span class="star" data-value="4">★</span>
                                <span class="star" data-value="5">★</span>
                            </div>
                            <input type="hidden" name="rating" id="rating-value" value="0">
                            <textarea name="comment" placeholder="Nhập bình luận của bạn..." rows="4" required></textarea>
                            <button type="submit">Gửi đánh giá</button>
                        </form>
                    </div>
                    <% } else { %>
                    <p>Vui lòng <a href="login-regis.jsp">đăng nhập</a> để viết đánh giá.</p>
                    <% } %>

                    <div class="review-list">
                        <%
                            ReviewDAO reviewDAO = new ReviewDAO();
                            UserDAO userDAO = new UserDAO();
                            List<ReviewDTO> reviews = reviewDAO.getReviewsByRoomId(room.getId());
                            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                            if (reviews != null && !reviews.isEmpty()) {
                                for (ReviewDTO review : reviews) {
                                    UserDTO reviewer = userDAO.readById(review.getUserId());
                                    String reviewerName = reviewer != null ? reviewer.getFullName() : review.getUserId();
                                    // Tạo chuỗi sao bằng StringBuilder
                                    StringBuilder stars = new StringBuilder();
                                    int rating = (int) review.getRating();
                                    for (int i = 0; i < rating; i++) {
                                        stars.append("⭐");
                                    }
                        %>
                        <div class="review-item">
                            <p><strong><%= reviewerName %>:</strong></p>
                            <p class="rating"><%= stars.toString() %></p>
                            <p><%= review.getComment() %></p>
                            <p><small><%= sdf.format(review.getCreatedAt()) %></small></p>
                        </div>
                        <%
                                }
                            } else {
                        %>
                        <p>Chưa có đánh giá nào cho phòng này.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>

        <div class="footer-container">
            <%@include file="footer.jsp" %>
        </div>

        <!-- JavaScript -->
        <script>
            // Slideshow
            var currentIndex = 0;
            var images = document.querySelectorAll('.room-gallery img');
            function showImage(index) {
                images.forEach(function(img, i) {
                    img.classList.remove('active');
                    if (i === index) img.classList.add('active');
                });
            }
            function changeImage(direction) {
                currentIndex += direction;
                if (currentIndex < 0) currentIndex = images.length - 1;
                else if (currentIndex >= images.length) currentIndex = 0;
                showImage(currentIndex);
            }
            showImage(currentIndex);

            // Rating Stars
            var stars = document.querySelectorAll('.rating-stars .star');
            var ratingInput = document.getElementById('rating-value');
            stars.forEach(function(star) {
                star.addEventListener('click', function() {
                    var value = star.getAttribute('data-value');
                    ratingInput.value = value;
                    stars.forEach(function(s) {
                        s.classList.remove('active');
                        if (s.getAttribute('data-value') <= value) s.classList.add('active');
                    });
                });
            });
        </script>
    </body>
</html>