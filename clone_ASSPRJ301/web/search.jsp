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
        /* Thiết kế chung */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            padding-top: 80px; /* Thêm padding-top để tránh header che mất */
        }

        .search-container {
            max-width: 1200px;
            margin: 30px auto;
            background: rgba(255, 255, 255, 0.95);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            backdrop-filter: blur(5px);
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 25px;
        }

        /* Bộ lọc */
        .filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            padding: 20px;
            background: #ecf0f1;
            border-radius: 10px;
            justify-content: space-between;
            align-items: center;
            max-width: 100%;
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
            white-space: nowrap;
        }

        .filter-section input,
        .filter-section select {
            padding: 10px 12px;
            width: 100%;
            max-width: 220px;
            border: 1px solid #dfe6e9;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
            transition: border-color 0.3s, box-shadow 0.3s;
        }

        .filter-section input:focus,
        .filter-section select:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
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
            background: linear-gradient(45deg, #2ecc71, #27ae60);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            flex: 0 0 auto;
        }

        .filter-section button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(46, 204, 113, 0.3);
        }

        .filter-section button:active {
            transform: translateY(0);
        }

        /* Danh sách phòng */
        .room-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            padding: 0 15px;
        }

        .room-item {
            background: #fff;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
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
            color: #2980b9;
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
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .room-item button:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }

        .room-item button:active {
            transform: translateY(0);
        }
    </style>
</head>
<body>

<div class="search-container">
    <h2>Tìm kiếm Homestay</h2>

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
                <p><%= room.getDescription() %></p>
                <p>Giá: <%= room.getPrice() %> VND</p>
                <p>Tiện ích: <%= room.getAmenities() %></p>
                <p>Đánh giá: <%= room.getRatings() %>/5</p>
                <button onclick="bookRoom(<%= room.getId() %>)">Xem chi tiết</button>
            </div>
        <% } %>
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
                $("#roomList").html(response);
            }
        });
    });
});

function bookRoom(roomId) {
    window.location.href = "room-details?roomId=" + roomId;
}
</script>

</body>
</html>