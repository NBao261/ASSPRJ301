<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dto.RoomDTO"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý phòng - Admin</title>
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
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
            }
            .main-content {
                flex: 1;
                padding: 100px 20px;
                max-width: 1300px;
                margin: 0 auto;
                width: 95%;
            }
            .rooms-container {
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
            h1 {
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
            .btn {
                padding: 10px 18px;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                color: white;
                transition: transform 0.3s ease, background 0.3s ease;
                margin-right: 8px;
            }
            .btn-add {
                background: #27ae60;
            }
            .btn-add:hover {
                background: #219653;
                transform: scale(1.05);
            }
            .btn-edit {
                background: #3498db;
            }
            .btn-edit:hover {
                background: #2980b9;
                transform: scale(1.05);
            }
            .btn-delete {
                background: #e74c3c;
            }
            .btn-delete:hover {
                background: #c0392b;
                transform: scale(1.05);
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 30px;
                background: #fff;
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                table-layout: fixed;
            }
            th, td {
                padding: 18px;
                text-align: center;
                border-bottom: 1px solid #eee;
                word-wrap: break-word;
            }
            th {
                background: linear-gradient(45deg, #1abc9c, #16a085);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                width: 12.5%;
            }
            tr:hover {
                background: #f5f7fa;
                transition: background 0.3s ease;
            }
            td.actions {
                display: flex;
                justify-content: center;
                gap: 8px;
                align-items: center;
            }
            .message {
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 500;
            }
            .message.success {
                background: #e8f5e9;
                color: #27ae60;
            }
            .message.error {
                background: #ffebee;
                color: #e74c3c;
            }
            .no-data {
                text-align: center;
                padding: 30px;
                color: #7f8c8d;
                font-size: 18px;
            }
            .form-container {
                background: #f9fbfc;
                padding: 25px;
                border-radius: 15px;
                margin-bottom: 30px;
                display: none;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
            }
            .form-container.active {
                display: block;
            }
            .form-container label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #34495e;
            }
            .form-container input, .form-container textarea {
                width: 100%;
                padding: 12px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }
            .form-container input:focus, .form-container textarea:focus {
                border-color: #1abc9c;
                outline: none;
            }
            .form-container textarea {
                height: 120px;
                resize: vertical;
            }
            .form-container .note {
                font-size: 12px;
                color: #7f8c8d;
                margin-top: -10px;
                margin-bottom: 15px;
            }
            .image-preview {
                max-width: 120px;
                height: auto;
                margin: 5px;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 30px;
                gap: 10px;
            }
            .pagination a {
                padding: 10px 15px;
                background: #1abc9c;
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-weight: 500;
                transition: background 0.3s ease, transform 0.3s ease;
            }
            .pagination a:hover {
                background: #16a085;
                transform: scale(1.05);
            }
            .pagination a.disabled {
                background: #bdc3c7;
                cursor: not-allowed;
                pointer-events: none;
            }
            .pagination a.active {
                background: #16a085;
                font-weight: 700;
            }
            @media (max-width: 768px) {
                .main-content {
                    padding: 60px 15px;
                }
                h1 {
                    font-size: 32px;
                }
                th, td {
                    padding: 12px;
                    font-size: 14px;
                }
                .btn {
                    padding: 8px 12px;
                    font-size: 14px;
                }
                table {
                    display: block;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                .image-preview {
                    max-width: 80px;
                }
                .form-container {
                    padding: 15px;
                }
                .form-container input, .form-container textarea {
                    padding: 10px;
                }
                th {
                    width: auto;
                }
                .pagination a {
                    padding: 8px 12px;
                    font-size: 14px;
                }
            }
        </style>
    </head>
    <body>
        <div class="header-container">
            <%@include file="../header.jsp" %>
        </div>

        <div class="main-content">
            <div class="rooms-container">
                <%
                    Object userObj = session.getAttribute("user");
                    if (userObj == null || !"AD".equals(((dto.UserDTO) userObj).getRoleID())) {
                        response.sendRedirect(request.getContextPath() + "/login-regis.jsp");
                    } else {
                %>
                <h1>Quản lý phòng</h1>
                <a href="<%= request.getContextPath()%>/admin/dashboard.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Quay lại Dashboard</a>
                <button class="btn btn-add" onclick="toggleForm('addForm')"><i class="fas fa-plus"></i> Thêm phòng</button>

                <%
                    String successMessage = (String) request.getAttribute("successMessage");
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (successMessage != null) {
                %>
                <div class="message success"><%= successMessage%></div>
                <% } else if (errorMessage != null) {%>
                <div class="message error"><%= errorMessage%></div>
                <% }%>

                <!-- Form thêm phòng -->
                <div class="form-container" id="addForm">
                    <form action="<%= request.getContextPath()%>/admin/rooms?action=add" method="post">
                        <label for="addName">Tên phòng:</label>
                        <input type="text" id="addName" name="name" required>

                        <label for="addDescription">Mô tả:</label>
                        <textarea id="addDescription" name="description"></textarea>

                        <label for="addPrice">Giá (VND):</label>
                        <input type="number" id="addPrice" name="price" step="1000" min="0" required>

                        <label for="addAmenities">Tiện nghi:</label>
                        <input type="text" id="addAmenities" name="amenities">

                        <label for="addRatings">Đánh giá (0-5):</label>
                        <input type="number" id="addRatings" name="ratings" step="0.1" min="0" max="5" required>

                        <label for="addImageUrl">URL hình ảnh chính:</label>
                        <input type="text" id="addImageUrl" name="imageUrl" placeholder="Nhập link ảnh">
                        <div class="note">Nhập link ảnh bất kỳ</div>

                        <label for="addDetailImages">URL ảnh chi tiết (mỗi dòng một URL):</label>
                        <textarea id="addDetailImages" name="detailImages" placeholder="Nhập các link ảnh, mỗi dòng một link"></textarea>
                        <div class="note">Nhập từng link ảnh chi tiết trên một dòng</div>

                        <button type="submit" class="btn btn-add">Lưu</button>
                        <button type="button" class="btn btn-delete" onclick="toggleForm('addForm')">Hủy</button>
                    </form>
                </div>

                <!-- Form sửa phòng -->
                <%
                    RoomDTO editRoom = (RoomDTO) request.getAttribute("editRoom");
                    boolean showEditForm = editRoom != null;
                    String detailImagesText = showEditForm && editRoom.getDetailImages() != null ? String.join("\n", editRoom.getDetailImages()) : "";
                %>
                <div class="form-container <%= showEditForm ? "active" : ""%>" id="editForm">
                    <form action="<%= request.getContextPath()%>/admin/rooms?action=edit" method="post">
                        <input type="hidden" name="roomId" value="<%= showEditForm ? editRoom.getId() : ""%>">

                        <label for="editName">Tên phòng:</label>
                        <input type="text" id="editName" name="name" value="<%= showEditForm ? editRoom.getName() : ""%>" required>

                        <label for="editDescription">Mô tả:</label>
                        <textarea id="editDescription" name="description"><%= showEditForm && editRoom.getDescription() != null ? editRoom.getDescription() : ""%></textarea>

                        <label for="editPrice">Giá (VND):</label>
                        <input type="number" id="editPrice" name="price" step="1000" min="0" value="<%= showEditForm ? editRoom.getPrice() : ""%>" required>

                        <label for="editAmenities">Tiện nghi:</label>
                        <input type="text" id="editAmenities" name="amenities" value="<%= showEditForm && editRoom.getAmenities() != null ? editRoom.getAmenities() : ""%>">

                        <label for="editRatings">Đánh giá (0-5):</label>
                        <input type="number" id="editRatings" name="ratings" step="0.1" min="0" max="5" value="<%= showEditForm ? editRoom.getRatings() : ""%>" required>

                        <label for="editImageUrl">URL hình ảnh chính:</label>
                        <input type="text" id="editImageUrl" name="imageUrl" value="<%= showEditForm && editRoom.getImageUrl() != null ? editRoom.getImageUrl() : ""%>" placeholder="Nhập link ảnh">
                        <div class="note">Nhập link ảnh bất kỳ</div>

                        <label for="editDetailImages">URL ảnh chi tiết (mỗi dòng một URL):</label>
                        <textarea id="editDetailImages" name="detailImages" placeholder="Nhập các link ảnh, mỗi dòng một link"><%= detailImagesText%></textarea>
                        <div class="note">Nhập từng link ảnh chi tiết trên một dòng</div>

                        <button type="submit" class="btn btn-add">Lưu</button>
                        <button type="button" class="btn btn-delete" onclick="toggleForm('editForm')">Hủy</button>
                    </form>
                </div>

                <%
                    List<RoomDTO> roomList = (List<RoomDTO>) request.getAttribute("roomList");
                    if (roomList == null || roomList.isEmpty()) {
                %>
                <p class="no-data">Không có phòng nào trong hệ thống.</p>
                <%
                } else {
                    // Phân trang
                    final int ITEMS_PER_PAGE = 5; // Số lượng phòng trên mỗi trang
                    int currentPage = 1;
                    String pageParam = request.getParameter("page");
                    if (pageParam != null) {
                        try {
                            currentPage = Integer.parseInt(pageParam);
                        } catch (NumberFormatException e) {
                            currentPage = 1;
                        }
                    }

                    int totalRooms = roomList.size();
                    int totalPages = (int) Math.ceil((double) totalRooms / ITEMS_PER_PAGE);
                    if (currentPage < 1) currentPage = 1;
                    if (currentPage > totalPages) currentPage = totalPages;

                    int start = (currentPage - 1) * ITEMS_PER_PAGE;
                    int end = Math.min(start + ITEMS_PER_PAGE, totalRooms);
                    List<RoomDTO> roomsToShow = totalRooms > 0 ? roomList.subList(start, end) : roomList;
                %>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên phòng</th>
                            <th>Mô tả</th>
                            <th>Giá (VND)</th>
                            <th>Tiện nghi</th>
                            <th>Đánh giá</th>
                            <th>Hình ảnh chính</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (RoomDTO room : roomsToShow) {%>
                        <tr>
                            <td><%= room.getId()%></td>
                            <td><%= room.getName()%></td>
                            <td><%= room.getDescription() != null ? room.getDescription() : "Chưa có mô tả"%></td>
                            <td><%= String.format("%,.0f", room.getPrice())%></td>
                            <td><%= room.getAmenities() != null ? room.getAmenities() : "Chưa có tiện nghi"%></td>
                            <td><%= room.getRatings()%></td>
                            <td>
                                <% if (room.getImageUrl() != null && !room.getImageUrl().isEmpty()) {%>
                                <img src="<%= room.getImageUrl()%>" alt="Hình ảnh chính" class="image-preview" onerror="this.src='<%= request.getContextPath()%>/images/placeholder.jpg';">
                                <% } else { %>
                                Chưa có ảnh
                                <% }%>
                            </td>
                            <td class="actions">
                                <a href="<%= request.getContextPath()%>/admin/rooms?action=edit&roomId=<%= room.getId()%>&page=<%= currentPage%>" class="btn btn-edit"><i class="fas fa-edit"></i> Sửa</a>
                                <button class="btn btn-delete" onclick="confirmDelete('<%= room.getId()%>', <%= currentPage%>)"><i class="fas fa-trash"></i> Xóa</button>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>

                <!-- Phân trang -->
                <div class="pagination">
                    <% if (currentPage > 1) { %>
                    <a href="<%= request.getContextPath()%>/admin/rooms?page=<%= currentPage - 1%>">Trang trước</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang trước</a>
                    <% } %>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <a href="<%= request.getContextPath()%>/admin/rooms?page=<%= i%>" class="<%= (i == currentPage) ? "active" : ""%>"><%= i%></a>
                    <% } %>

                    <% if (currentPage < totalPages) { %>
                    <a href="<%= request.getContextPath()%>/admin/rooms?page=<%= currentPage + 1%>">Trang sau</a>
                    <% } else { %>
                    <a href="#" class="disabled">Trang sau</a>
                    <% } %>
                </div>
                <%
                    }
                %>
                <% }%>
            </div>
        </div>

        <div class="footer-container">
            <%@include file="../footer.jsp" %>
        </div>

        <script>
            function toggleForm(formId) {
                const form = document.getElementById(formId);
                form.classList.toggle('active');
            }

            function confirmDelete(roomId, page) {
                if (confirm("Bạn có chắc chắn muốn xóa phòng này không?")) {
                    window.location.href = '<%= request.getContextPath()%>/admin/rooms?action=delete&roomId=' + roomId + '&page=' + page;
                }
            }
        </script>
    </body>
</html>