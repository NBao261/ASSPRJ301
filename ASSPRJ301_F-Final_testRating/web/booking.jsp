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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link rel="stylesheet" href="<%= request.getContextPath()%>/assets/css/booking.css">
    </head>
    <body>
        <div class="header-container">
            <%@include file="header.jsp" %>
        </div>

        <div class="main-content">
            <%
                if (room == null) {
            %>
            <div class="no-room-container">
                <i class="fas fa-home-alt no-room-icon"></i>
                <h2 class="no-room-title">Không tìm thấy thông tin phòng!</h2>
                <a href="home.jsp" class="btn-back"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>
            </div>
            <%
            } else {
            %>
            <div class="booking-container">
                <div class="room-slideshow-container">
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
                        <img src="<%= imageUrl%>" alt="<%= room.getName()%>" class="<%= activeClass%>">
                        <%
                            }
                        %>
                        <div class="slideshow-overlay"></div>
                        <button class="prev" onclick="changeImage(-1)"><i class="fas fa-chevron-left"></i></button>
                        <button class="next" onclick="changeImage(1)"><i class="fas fa-chevron-right"></i></button>

                        <div class="slideshow-controls">
                            <%
                                for (int i = 0; i < detailImages.size(); i++) {
                                    String activeClass = (i == 0) ? "active" : "";
                            %>
                            <div class="slideshow-indicator <%= activeClass%>" onclick="showImageDirect(<%= i%>)"></div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

                <div class="booking-content">
                    <div class="booking-details">
                        <h1 class="booking-room-name"><%= room.getName()%></h1>
                        <div class="price-tag"><i class="fas fa-tag"></i> <span id="room-price"><%= room.getPrice()%></span> đ / đêm</div>

                        <p class="booking-description"><%= room.getDescription()%></p>

                        <div class="detail-item">
                            <i class="fas fa-star"></i>
                            <div class="ratings-display">
                                <strong>Đánh giá:</strong>
                                <div class="stars">
                                    <%
                                        double rating = room.getAverageRating();
                                        for (int i = 1; i <= 5; i++) {
                                            if (i <= rating) {
                                    %>
                                    <i class="fas fa-star"></i>
                                    <%
                                    } else if (i - rating < 1 && i - rating > 0) {
                                    %>
                                    <i class="fas fa-star-half-alt"></i>
                                    <%
                                    } else {
                                    %>
                                    <i class="far fa-star"></i>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                                (<%= room.getAverageRating()%>)
                            </div>
                        </div>

                        <div class="detail-item">
                            <i class="fas fa-wifi"></i>
                            <div>
                                <strong>Tiện nghi:</strong>
                                <div class="amenities-list">
                                    <%
                                        String amenities = room.getAmenities();
                                        if (amenities != null && !amenities.isEmpty()) {
                                            String[] amenitiesList = amenities.split(",");
                                            for (String amenity : amenitiesList) {
                                                amenity = amenity.trim();
                                                String icon = "fas fa-check";

                                                if (amenity.toLowerCase().contains("wifi")) {
                                                    icon = "fas fa-wifi";
                                                } else if (amenity.toLowerCase().contains("điều hòa")) {
                                                    icon = "fas fa-snowflake";
                                                } else if (amenity.toLowerCase().contains("tivi")) {
                                                    icon = "fas fa-tv";
                                                } else if (amenity.toLowerCase().contains("nước")) {
                                                    icon = "fas fa-water";
                                                } else if (amenity.toLowerCase().contains("bếp")) {
                                                    icon = "fas fa-utensils";
                                                } else if (amenity.toLowerCase().contains("giặt")) {
                                                    icon = "fas fa-tshirt";
                                                } else if (amenity.toLowerCase().contains("đỗ xe")) {
                                                    icon = "fas fa-parking";
                                                }
                                    %>
                                    <div class="amenity-tag"><i class="<%= icon%>"></i> <%= amenity%></div>
                                    <%
                                            }
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (errorMessage != null) {%>
                    <div class="message error"><i class="fas fa-exclamation-circle"></i> <%= errorMessage%></div>
                    <% } %>
                    <% if (successMessage != null) {%>
                    <div class="message success"><i class="fas fa-check-circle"></i> <%= successMessage%></div>
                    <% }%>

                    <div class="booking-form-container">
                        <h3 class="form-title"><i class="fas fa-calendar-check"></i> Đặt phòng ngay</h3>

                        <form action="bookRoom" method="post" onsubmit="return validateForm()" class="booking-form">
                            <input type="hidden" name="roomId" value="<%= room.getId()%>">

                            <div class="form-group">
                                <label for="checkInDate"><i class="fas fa-calendar-plus"></i> Ngày nhận phòng:</label>
                                <input type="date" id="checkInDate" name="checkInDate" required onchange="checkAvailability()">
                            </div>

                            <div class="form-group">
                                <label for="checkOutDate"><i class="fas fa-calendar-minus"></i> Ngày trả phòng:</label>
                                <input type="date" id="checkOutDate" name="checkOutDate" required onchange="checkAvailability()">
                            </div>

                            <div class="total-price">
                                <span>Tổng tiền:</span>
                                <span class="total-price-amount"><span id="total-price">0</span> đ</span>
                            </div>

                            <div id="availability-message" class="availability-message" style="display: none;"></div>

                            <button type="submit" id="bookButton" class="btn-book" disabled>
                                <i class="fas fa-check-circle"></i> Xác nhận đặt phòng
                            </button>
                        </form>
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

        <script>
            let currentIndex = 0;
            const images = document.querySelectorAll('.room-slideshow img');
            const indicators = document.querySelectorAll('.slideshow-indicator');

            function showImage(index) {
                images.forEach((img, i) => {
                    img.classList.remove('active');
                    indicators[i].classList.remove('active');
                    if (i === index) {
                        img.classList.add('active');
                        indicators[i].classList.add('active');
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

            function showImageDirect(index) {
                currentIndex = index;
                showImage(currentIndex);
            }

// Auto slideshow
            let slideshowInterval = setInterval(() => {
                changeImage(1);
            }, 5000);

// Reset interval when manually changing images
            document.querySelector('.room-slideshow').addEventListener('click', () => {
                clearInterval(slideshowInterval);
                slideshowInterval = setInterval(() => {
                    changeImage(1);
                }, 5000);
            });

            showImage(currentIndex);

            function validateForm() {
                let checkIn = new Date(document.getElementById("checkInDate").value);
                let checkOut = new Date(document.getElementById("checkOutDate").value);
                let today = new Date();
                today.setHours(0, 0, 0, 0); // Set to start of day for fair comparison

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
                let pricePerNight = <%= room != null ? room.getPrice() : 0%>;
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
                let roomId = <%= room != null ? room.getId() : -1%>;
                let checkInDate = document.getElementById("checkInDate").value;
                let checkOutDate = document.getElementById("checkOutDate").value;
                let bookButton = document.getElementById("bookButton");
                let availabilityMessage = document.getElementById("availability-message");

                calculateTotal(); // Tính tổng tiền khi thay đổi ngày

                if (checkInDate && checkOutDate && validateDates()) {
                    let xhr = new XMLHttpRequest();
                    xhr.open("GET", "checkAvailability?roomId=" + roomId + "&checkInDate=" + checkInDate + "&checkOutDate=" + checkOutDate, true);
                    xhr.onreadystatechange = function () {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            let response = JSON.parse(xhr.responseText);
                            if (response.available) {
                                availabilityMessage.style.display = "flex";
                                availabilityMessage.className = "availability-message available";
                                availabilityMessage.innerHTML = '<i class="fas fa-check-circle"></i> Phòng còn trống cho khoảng thời gian bạn chọn';
                                bookButton.disabled = false;
                            } else {
                                availabilityMessage.style.display = "flex";
                                availabilityMessage.className = "availability-message unavailable";
                                availabilityMessage.innerHTML = '<i class="fas fa-times-circle"></i> Phòng đã được đặt trong khoảng thời gian này';
                                bookButton.disabled = true;
                            }
                        } else if (xhr.readyState === 4) {
                            availabilityMessage.style.display = "flex";
                            availabilityMessage.className = "availability-message unavailable";
                            availabilityMessage.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Lỗi khi kiểm tra trạng thái phòng';
                            bookButton.disabled = true;
                        }
                    };
                    xhr.send();
                } else {
                    availabilityMessage.style.display = "none";
                    bookButton.disabled = true;
                }
            }

            function validateDates() {
                let checkIn = new Date(document.getElementById("checkInDate").value);
                let checkOut = new Date(document.getElementById("checkOutDate").value);
                let today = new Date();
                today.setHours(0, 0, 0, 0);

                return checkIn >= today && checkOut > checkIn;
            }

// Format price display on load
            window.onload = function () {
                const priceElement = document.getElementById("room-price");
                if (priceElement) {
                    const price = parseInt(priceElement.innerText);
                    priceElement.innerText = price.toLocaleString();
                }

                // Set min date for date inputs
                const today = new Date().toISOString().split('T')[0];
                document.getElementById("checkInDate").min = today;
                document.getElementById("checkOutDate").min = today;
            };
        </script>
    </body>
</html>