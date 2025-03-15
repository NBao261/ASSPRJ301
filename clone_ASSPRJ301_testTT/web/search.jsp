<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.RoomDTO"%>
<%@page import="dao.RoomDAO"%>
<%@include file="header.jsp" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tìm kiếm Homestay</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            padding-top: 80px;
        }

        .main-content {
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
            padding: 80px 0;
            gap: 50px;
        }

        .search-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 30%;
            max-width: 350px;
            position: fixed;
            top: 80px;
            height: calc(100vh - 80px);
            overflow-y: auto;
            z-index: 10;
        }

        .search-container:hover {
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.15);
        }

        h2 {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 30px;
            text-align: center;
        }

        .back-link {
            display: inline-block;
            color: #3498db;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #2980b9;
        }

        .filter-section {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 10px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .filter-section label {
            font-weight: 600;
            color: #2c3e50;
            font-size: 15px;
        }

        .filter-section input,
        .filter-section select {
            padding: 10px 12px;
            width: 100%;
            border: 1px solid #eee;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            transition: border-color 0.3s;
        }

        .filter-section input:focus,
        .filter-section select:focus {
            outline: none;
            border-color: #3498db;
        }

        .price-filter {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* CSS cho thanh kéo giá */
        .slider-container {
            position: relative;
            width: 100%;
            height: 5px;
            background: #ddd;
            border-radius: 5px;
        }

        .slider-container .range {
            position: absolute;
            height: 100%;
            background: #5DC1B9;
            border-radius: 5px;
        }

        .slider-container input[type="range"] {
            -webkit-appearance: none;
            appearance: none;
            width: 100%;
            height: 5px;
            background: transparent;
            position: absolute;
            top: 0;
            margin: 0;
            pointer-events: none;
        }

        .slider-container input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 15px;
            height: 15px;
            background: #5DC1B9;
            border-radius: 50%;
            cursor: pointer;
            pointer-events: auto;
        }

        .slider-container input[type="range"]::-moz-range-thumb {
            width: 15px;
            height: 15px;
            background: #5DC1B9;
            border-radius: 50%;
            cursor: pointer;
            pointer-events: auto;
        }

        .price-values {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
            font-size: 14px;
            color: #2c3e50;
        }

        .price-values span {
            background: #fff;
            padding: 5px 10px;
            border: 1px solid #eee;
            border-radius: 5px;
        }

        .filter-section button {
            background: linear-gradient(45deg, #5DC1B9, #4ECDC4);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .filter-section button:hover {
            background: linear-gradient(45deg, #4ECDC4, #5DC1B9);
            transform: scale(1.05);
        }

        .room-list-container {
            width: 65%;
            margin-left: calc(30% + 60px);
            padding-bottom: 20px;
        }

        .room-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            padding: 20px 0;
        }

        .room-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .room-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        .room-item img {
            width: 100%;
            height: 220px;
            object-fit: cover;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .room-item h3 {
            color: #2c3e50;
            font-size: 22px;
            font-weight: 600;
            margin: 0 0 10px;
        }

        .room-item p {
            font-size: 15px;
            color: #7f8c8d;
            line-height: 1.6;
            margin: 5px 0;
        }

        .room-item button {
            background: linear-gradient(45deg, #3498db, #2980b9);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.3s ease, background 0.3s ease;
        }

        .room-item button:hover {
            background: linear-gradient(45deg, #2980b9, #1f6391);
            transform: scale(1.05);
        }

        @media (max-width: 768px) {
            .main-content {
                flex-direction: column;
                padding: 60px 15px;
            }

            .search-container {
                position: static;
                width: 100%;
                max-width: none;
                height: auto;
                margin-bottom: 20px;
            }

            .room-list-container {
                width: 100%;
                margin-left: 0;
            }

            h2 {
                font-size: 28px;
            }

            .room-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="main-content">
    <!-- Phần lọc bên trái -->
    <div class="search-container">
        <h2>Tìm kiếm Homestay</h2>
        <a href="<%= request.getContextPath() %>/home.jsp" class="back-link">← Quay lại trang chủ</a>

        <div class="filter-section">
            <div class="filter-group">
                <label>Tên Homestay:</label>
                <input type="text" id="searchName" placeholder="Nhập tên homestay">
            </div>

            <div class="price-filter">
                <label>Giá:</label>
                <div class="slider-container">
                    <div class="range" id="priceRange"></div>
                    <input type="range" id="minPrice" min="1000000" max="10000000" value="1000000">
                    <input type="range" id="maxPrice" min="1000000" max="10000000" value="10000000">
                </div>
                <div class="price-values">
                    <span id="minPriceValue">1.000.000đ</span>
                    <span id="maxPriceValue">10.000.000đ</span>
                </div>
            </div>

            <div class="filter-group">
                <label>Tiện ích:</label>
                <select id="amenities">
                    <option value="">Tất cả</option>
                    <option value="WiFi">WiFi</option>
                    <option value="Bể bơi">Bể bơi</option>
                    <option value="Gym">Gym</option>
                </select>
            </div>

            <button id="filterBtn">Lọc ngay</button>
        </div>
    </div>

    <!-- Phần danh sách phòng bên phải -->
    <div class="room-list-container">
        <div id="roomList" class="room-list">
            <% 
                RoomDAO roomDAO = new RoomDAO();
                List<RoomDTO> rooms = roomDAO.getAllRooms();
                for (RoomDTO room : rooms) {
            %>
                <div class="room-item">
                    <img src="<%= room.getImageUrl() %>" alt="Hình ảnh phòng">
                    <h3><%= room.getName() %></h3>
                    <p><%= room.getDescription() != null ? room.getDescription() : "Chưa có mô tả" %></p>
                    <p>Giá: <%= String.format("%,.0f", room.getPrice()) %> VND</p>
                    <p>Tiện ích: <%= room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện ích" %></p>
                    <p>Đánh giá: <%= room.getRatings() %>/5</p>
                    <button onclick="roomDetails(<%= room.getId() %>)">Xem chi tiết</button>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    const minPriceSlider = document.getElementById("minPrice");
    const maxPriceSlider = document.getElementById("maxPrice");
    const minPriceValue = document.getElementById("minPriceValue");
    const maxPriceValue = document.getElementById("maxPriceValue");
    const priceRange = document.getElementById("priceRange");

    const minPrice = 1000000; // 1 triệu
    const maxPrice = 10000000; // 10 triệu

    function formatPrice(price) {
        return price.toLocaleString("vi-VN") + "đ";
    }

    function updatePriceRange() {
        const minVal = parseInt(minPriceSlider.value);
        const maxVal = parseInt(maxPriceSlider.value);

        // Đảm bảo min không lớn hơn max
        if (minVal > maxVal) {
            minPriceSlider.value = maxVal;
            return;
        }
        if (maxVal < minVal) {
            maxPriceSlider.value = minVal;
            return;
        }

        // Cập nhật giá trị hiển thị
        minPriceValue.textContent = formatPrice(minVal);
        maxPriceValue.textContent = formatPrice(maxVal);

        // Cập nhật thanh range
        const minPercent = ((minVal - minPrice) / (maxPrice - minPrice)) * 100;
        const maxPercent = ((maxVal - minPrice) / (maxPrice - minPrice)) * 100;
        priceRange.style.left = minPercent + "%";
        priceRange.style.width = (maxPercent - minPercent) + "%";
    }

    minPriceSlider.addEventListener("input", updatePriceRange);
    maxPriceSlider.addEventListener("input", updatePriceRange);

    // Khởi tạo giá trị ban đầu
    updatePriceRange();

    $("#filterBtn").click(function() {
        var searchName = $("#searchName").val();
        var minPrice = $("#minPrice").val();
        var maxPrice = $("#maxPrice").val();
        var amenities = $("#amenities").val();

        $.ajax({
            url: "RoomFilterServlet",
            type: "GET",
            data: {
                searchName: searchName,
                minPrice: minPrice,
                maxPrice: maxPrice,
                amenities: amenities
            },
            success: function(response) {
                $("#roomList").html(response);
            }
        });
    });
});

function roomDetails(roomId) {
    window.location.href = "room-details?roomId=" + roomId;
}
</script>

</body>
</html>