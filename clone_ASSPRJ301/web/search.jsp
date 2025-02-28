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
            padding-top: 80px; /* Thêm padding-top để tránh header che mất */
        }

        .main-content {
            flex: 1;
            padding: 80px 0;
            max-width: 1200px;
            margin: 0 auto;
            width: 90%;
        }

        .search-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            padding: 30px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .search-container:hover {
            transform: translateY(-5px);
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

        /* Bộ lọc */
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 10px;
            justify-content: space-between;
            align-items: center;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex: 1;
            min-width: 250px;
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
            max-width: 220px;
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
            align-items: center;
            gap: 15px;
            flex: 2;
            min-width: 350px;
        }

        .price-filter input[type="number"] {
            width: 120px;
        }

        .price-filter .radio-group {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .price-filter input[type="radio"] {
            width: auto;
            margin: 0 5px 0 0;
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

        /* Danh sách phòng */
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
                padding: 60px 15px;
            }

            h2 {
                font-size: 28px;
            }

            .filter-section {
                flex-direction: column;
                gap: 15px;
            }

            .filter-group,
            .price-filter {
                min-width: 100%;
            }

            .price-filter input[type="number"] {
                width: 100px;
            }

            .room-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>

<div class="main-content">
    <div class="search-container">
        <h2>Tìm kiếm Homestay</h2>
        <a href="<%= request.getContextPath() %>/home.jsp" class="back-link">← Quay lại trang chủ</a>

        <!-- Bộ lọc -->
        <div class="filter-section">
            <div class="filter-group">
                <label>Tên Homestay:</label>
                <input type="text" id="searchName" placeholder="Nhập tên homestay">
            </div>

            <div class="price-filter">
                <label>Giá:</label>
                <input type="number" id="maxPrice" placeholder="Nhập giá">
                <div class="radio-group">
                    <label><input type="radio" name="priceFilterType" value="below" checked> Dưới mức giá</label>
                    <label><input type="radio" name="priceFilterType" value="above"> Trên mức giá</label>
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

        <!-- Kết quả tìm kiếm -->
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
    $("#filterBtn").click(function() {
        var searchName = $("#searchName").val();
        var maxPrice = $("#maxPrice").val();
        var priceFilterType = $("input[name='priceFilterType']:checked").val();
        var amenities = $("#amenities").val();

        $.ajax({
            url: "RoomFilterServlet",
            type: "GET",
            data: {
                searchName: searchName,
                maxPrice: maxPrice,
                priceFilterType: priceFilterType,
                amenities: amenities
            },
            success: function(response) {
                $("#roomList").html(response); // Cập nhật danh sách phòng sau khi lọc
            }
        });
    });
});

function roomDetails(roomId) {
    window.location.href = "room-details?roomId=" + roomId; // Chuyển hướng đến chi tiết phòng
}
</script>

</body>
</html>