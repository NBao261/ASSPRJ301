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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
            }
            body {
                background: linear-gradient(120deg, #e0eafc 0%, #cfdef3 100%);
                color: #2c3e50;
                min-height: 100vh;
                padding-top: 80px; /* Tránh header che mất */
                overflow-x: hidden;
            }
            .main-content {
                flex: 1;
                padding: 100px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .search-container {
                background: #ffffff;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                padding: 40px;
                animation: fadeIn 0.5s ease-in;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            h2 {
                font-size: 42px;
                font-weight: 700;
                color: #1a3c34;
                margin-bottom: 30px;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .back-link {
                display: inline-flex;
                align-items: center;
                color: #1abc9c;
                text-decoration: none;
                font-weight: 600;
                margin-bottom: 25px;
                transition: color 0.3s ease, transform 0.3s ease;
            }
            .back-link:hover {
                color: #16a085;
                transform: translateX(-5px);
            }
            .back-link i {
                margin-right: 8px;
            }
            /* Bộ lọc */
            .filter-section {
                display: flex;
                flex-wrap: wrap;
                gap: 20px;
                padding: 20px;
                background: #f9fbfc;
                border-radius: 15px;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
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
                color: #34495e;
                font-size: 15px;
            }
            .filter-section input,
            .filter-section select {
                padding: 12px;
                width: 100%;
                max-width: 220px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                background: #fff;
                transition: border-color 0.3s ease;
            }
            .filter-section input:focus,
            .filter-section select:focus {
                outline: none;
                border-color: #1abc9c;
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
                background: linear-gradient(45deg, #1abc9c, #16a085);
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
                background: linear-gradient(45deg, #16a085, #138d75);
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
                border-radius: 15px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                text-align: center;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .room-item:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
            }
            .room-item img {
                width: 100%;
                height: 220px;
                object-fit: cover;
                border-radius: 10px;
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
            /* Phân trang */
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 30px;
                gap: 10px;
            }
            .pagination a {
                padding: 10px 15px;
                text-decoration: none;
                font-size: 16px;
                color: #2c3e50;
                background: #f9fbfc;
                border-radius: 5px;
                transition: background 0.3s ease, color 0.3s ease;
            }
            .pagination a:hover {
                background: #1abc9c;
                color: white;
            }
            .pagination .active {
                background: #1abc9c;
                color: white;
                font-weight: 600;
            }
            .pagination .disabled {
                color: #7f8c8d;
                background: #f1f3f5;
                pointer-events: none;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px;
                }
                h2 {
                    font-size: 32px;
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
                .room-item img {
                    height: 180px;
                }
                .pagination a {
                    padding: 8px 12px;
                    font-size: 14px;
                }
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <div class="search-container">
                <h2>Tìm kiếm Homestay</h2>
                <a href="<%= request.getContextPath()%>/home.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại trang chủ</a>

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
                        int roomsPerPage = 6; // Số lượng phòng mỗi trang
                        int currentPage = 1; // Trang hiện tại (mặc định là 1)

                        // Lấy tham số trang từ URL (nếu có)
                        String pageParam = request.getParameter("page");
                        if (pageParam != null && !pageParam.isEmpty()) {
                            try {
                                currentPage = Integer.parseInt(pageParam);
                            } catch (NumberFormatException e) {
                                currentPage = 1; // Nếu tham số không hợp lệ, mặc định là trang 1
                            }
                        }

                        // Tính toán tổng số phòng và tổng số trang
                        int totalRooms = roomDAO.getTotalRoomCount(); // Cần thêm phương thức này trong RoomDAO
                        int totalPages = (int) Math.ceil((double) totalRooms / roomsPerPage);

                        // Đảm bảo trang hiện tại nằm trong giới hạn hợp lệ
                        if (currentPage < 1) {
                            currentPage = 1;
                        } else if (currentPage > totalPages) {
                            currentPage = totalPages;
                        }

                        // Lấy danh sách phòng cho trang hiện tại
                        int offset = (currentPage - 1) * roomsPerPage;
                        List<RoomDTO> rooms = roomDAO.getRoomsByPage(offset, roomsPerPage); // Cần thêm phương thức này trong RoomDAO

                        if (rooms != null && !rooms.isEmpty()) {
                            for (RoomDTO room : rooms) {
                    %>
                    <div class="room-item">
                        <img src="<%= room.getImageUrl() != null && !room.getImageUrl().isEmpty() ? room.getImageUrl() : request.getContextPath() + "/images/placeholder.jpg"%>" alt="Hình ảnh phòng" onerror="this.src='<%= request.getContextPath() + "/images/placeholder.jpg"%>';">
                        <h3><%= room.getName()%></h3>
                        <p><%= room.getDescription() != null ? room.getDescription() : "Chưa có mô tả"%></p>
                        <p>Giá: <%= String.format("%,.0f", room.getPrice())%> VND</p>
                        <p>Tiện ích: <%= room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện ích"%></p>
                        <p>Đánh giá: <%= room.getRatings()%>/5</p>
                        <button onclick="roomDetails(<%= room.getId()%>)">Xem chi tiết</button>
                    </div>
                    <% 
                            }
                        } else {
                    %>
                    <p style="text-align: center; color: #e74c3c;">Không tìm thấy homestay nào!</p>
                    <% } %>
                </div>

                <!-- Phân trang -->
                <div class="pagination">
                    <% 
                        // Nút "Trang trước"
                        if (currentPage > 1) {
                    %>
                    <a href="<%= request.getContextPath() %>/search.jsp?page=<%= currentPage - 1 %>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% 
                        // Hiển thị các số trang
                        int startPage = Math.max(1, currentPage - 2);
                        int endPage = Math.min(totalPages, currentPage + 2);

                        for (int i = startPage; i <= endPage; i++) {
                    %>
                    <a href="<%= request.getContextPath() %>/search.jsp?page=<%= i %>" <%= (i == currentPage) ? "class='active'" : "" %>><%= i %></a>
                    <% } %>

                    <% 
                        // Nút "Trang sau"
                        if (currentPage < totalPages) {
                    %>
                    <a href="<%= request.getContextPath() %>/search.jsp?page=<%= currentPage + 1 %>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
                    <% } %>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                $("#filterBtn").click(function () {
                    var searchName = $("#searchName").val();
                    var maxPrice = $("#maxPrice").val();
                    var priceFilterType = $("input[name='priceFilterType']:checked").val();
                    var amenities = $("#amenities").val();
                    var currentPage = <%= currentPage %>; // Lấy trang hiện tại

                    $.ajax({
                        url: "RoomFilterController",
                        type: "GET",
                        data: {
                            searchName: searchName,
                            maxPrice: maxPrice,
                            priceFilterType: priceFilterType,
                            amenities: amenities,
                            page: currentPage // Truyền tham số trang để giữ phân trang sau khi lọc
                        },
                        success: function (response) {
                            $("#roomList").html(response); // Cập nhật danh sách phòng sau khi lọc
                            // Cập nhật lại phân trang nếu cần (có thể cần thêm logic phía server để trả về thông tin phân trang)
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