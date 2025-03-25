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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
        }

        body {
            background: linear-gradient(135deg, #4a704a 0%, #d4e4bc 50%, #f7e7ce 100%);
            color: #fff;
            min-height: 100vh;
            padding-top: 80px;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://www.transparenttextures.com/patterns/wood-pattern.png');
            opacity: 0.1;
            z-index: -1;
        }

        .main-content {
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            width: 90%;
            padding: 80px 0;
            gap: 70px;
            position: relative;
        }

        /* Search Container */
        .search-container {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 25px;
            box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
            padding: 20px;
            width: 30%;
            max-width: 400px;
            position: fixed;
            top: 100px;
            overflow-y: auto;
            z-index: 10;
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideInLeft 0.8s ease-out;
        }

        @keyframes slideInLeft {
            from { transform: translateX(-100%); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        .search-container:hover {
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            transform: translateY(-5px);
        }

        h2 {
            font-size: 32px;
            font-weight: 700;
            color: #fff;
            margin-bottom: 20px;
            text-align: center;
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
            letter-spacing: 1px;
            position: relative;
        }

        h2::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 50%;
            width: 50px;
            height: 3px;
            background: linear-gradient(90deg, #f4a261, #e9c46a);
            transform: translateX(-50%);
            border-radius: 5px;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: #f4a261;
            text-decoration: none;
            font-weight: 600;
            margin-bottom: 15px;
            transition: all 0.3s ease;
            text-shadow: 0 1px 5px rgba(0, 0, 0, 0.2);
        }

        .back-link:hover {
            color: #fff;
            transform: translateX(5px);
        }

        .filter-section {
            display: flex;
            flex-direction: column;
            gap: 15px;
            padding: 20px;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 20px;
            box-shadow: inset 0 2px 15px rgba(0, 0, 0, 0.1);
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .filter-section label {
            font-weight: 600;
            color: #fff;
            font-size: 15px;
            letter-spacing: 0.5px;
            text-shadow: 0 1px 5px rgba(0, 0, 0, 0.2);
        }

        .filter-section input,
        .filter-section select {
            padding: 10px 14px;
            width: 100%;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            background: rgba(255, 255, 255, 0.9);
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .filter-section input:focus,
        .filter-section select:focus {
            outline: none;
            background: #fff;
            box-shadow: 0 0 12px rgba(244, 162, 97, 0.5);
        }

        .price-filter {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        /* Price Slider */
        .slider-container {
            position: relative;
            width: 100%;
            height: 8px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 8px;
            margin-top: 15px;
        }

        .slider-container .range {
            position: absolute;
            height: 100%;
            background: linear-gradient(90deg, #f4a261, #e9c46a);
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(244, 162, 97, 0.5);
        }

        .slider-container input[type="range"] {
            -webkit-appearance: none;
            appearance: none;
            width: 100%;
            height: 8px;
            background: transparent;
            position: absolute;
            top: 0;
            margin: 0;
            pointer-events: none;
        }

        .slider-container input[type="range"]::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 20px;
            height: 20px;
            background: #fff;
            border: 4px solid #f4a261;
            border-radius: 50%;
            cursor: pointer;
            pointer-events: auto;
            transition: all 0.3s ease;
            box-shadow: 0 0 10px rgba(244, 162, 97, 0.5);
        }

        .slider-container input[type="range"]::-webkit-slider-thumb:hover {
            transform: scale(1.2);
            border-color: #e9c46a;
        }

        .slider-container input[type="range"]::-moz-range-thumb {
            width: 20px;
            height: 20px;
            background: #fff;
            border: 4px solid #f4a261;
            border-radius: 50%;
            cursor: pointer;
            pointer-events: auto;
            box-shadow: 0 0 10px rgba(244, 162, 97, 0.5);
        }

        .price-values {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            font-size: 14px;
            color: #fff;
            text-shadow: 0 1px 5px rgba(0, 0, 0, 0.2);
        }

        .price-values span {
            background: rgba(255, 255, 255, 0.9);
            padding: 6px 12px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            color: #4a704a;
        }

        .filter-section button {
            background: linear-gradient(45deg, #f4a261, #e9c46a);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s ease;
            box-shadow: 0 6px 20px rgba(244, 162, 97, 0.4);
            position: relative;
            overflow: hidden;
        }

        .filter-section button::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.6s ease, height 0.6s ease;
        }

        .filter-section button:hover::before {
            width: 300px;
            height: 300px;
        }

        .filter-section button:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(244, 162, 97, 0.5);
        }

        /* Room List */
        .room-list-container {
            width: 65%;
            margin-left: calc(30% + 80px);
            padding-bottom: 40px;
        }

        .room-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 30px;
            padding: 20px 0;
        }

        .room-item {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            transition: all 0.4s ease;
            position: relative;
            min-height: 420px;
            display: flex;
            flex-direction: column;
        }

        .room-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
        }

        .room-content {
            padding: 25px;
            text-align: left;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
        }

        .room-image {
            position: relative;
            width: 100%;
            height: 200px;
            margin-bottom: 20px;
        }

        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            transition: all 0.4s ease;
        }

        .room-image::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.2);
            opacity: 0;
            border-radius: 10px;
            transition: opacity 0.4s ease;
        }

        .room-item:hover .room-image::after {
            opacity: 1;
        }

        .room-item:hover .room-image img {
            transform: scale(1.03);
        }

        .room-content h3 {
            color: #4a704a;
            font-size: 18px;
            font-weight: 600;
            margin: 0 0 12px;
            transition: color 0.3s ease;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .room-item:hover .room-content h3 {
            color: #e76f51;
        }

        .room-content p {
            font-size: 13px;
            color: #555;
            line-height: 1.6;
            margin: 8px 0;
            font-weight: 400;
            display: flex;
            align-items: center;
            gap: 8px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .room-content p i {
            color: #f4a261;
            font-size: 14px;
        }

        .room-content button {
            background: linear-gradient(45deg, #f4a261, #e9c46a);
            color: white;
            border: none;
            padding: 10px 0;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.4s ease;
            margin-top: 15px;
            width: 100%;
            box-shadow: 0 4px 15px rgba(244, 162, 97, 0.3);
        }

        .room-content button:hover {
            background: linear-gradient(45deg, #e76f51, #e9c46a);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(244, 162, 97, 0.5);
        }

        @media (max-width: 768px) {
            .main-content {
                flex-direction: column;
                padding: 60px 20px;
            }

            .search-container {
                position: static;
                width: 100%;
                max-width: none;
                height: auto;
                margin-bottom: 40px;
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

            .room-item {
                min-height: 400px;
            }

            .room-image {
                height: 180px;
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
                    <div class="room-content">
                        <div class="room-image">
                            <img src="<%= room.getImageUrl() %>" alt="Hình ảnh phòng">
                        </div>
                        <h3><%= room.getName() %></h3>
                        <p><i class="fas fa-tag"></i> Khởi giá từ <%= String.format("%,.0f", room.getPrice()) %> VND</p>
                        <p><i class="fas fa-wifi"></i> Tiện ích: <%= room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện ích" %></p>
                        <p><i class="fas fa-star"></i> Đánh giá: <%= room.getRatings() %>/5</p>
                        <button onclick="roomDetails(<%= room.getId() %>)">Xem chi tiết</button>
                    </div>
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

        if (minVal > maxVal) {
            minPriceSlider.value = maxVal;
            return;
        }
        if (maxVal < minVal) {
            maxPriceSlider.value = minVal;
            return;
        }

        minPriceValue.textContent = formatPrice(minVal);
        maxPriceValue.textContent = formatPrice(maxVal);

        const minPercent = ((minVal - minPrice) / (maxPrice - minPrice)) * 100;
        const maxPercent = ((maxVal - minPrice) / (maxPrice - minPrice)) * 100;
        priceRange.style.left = minPercent + "%";
        priceRange.style.width = (maxPercent - minPercent) + "%";
    }

    minPriceSlider.addEventListener("input", updatePriceRange);
    maxPriceSlider.addEventListener("input", updatePriceRange);

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
                $("#roomList").css({
                    'display': 'grid',
                    'grid-template-columns': 'repeat(auto-fill, minmax(320px, 1fr))',
                    'gap': '30px',
                    'padding': '20px 0'
                });
            },
            error: function(xhr, status, error) {
                console.error("Lỗi khi lọc phòng: ", error);
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